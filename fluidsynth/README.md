# FluidEngine, FluidInstrument, FluidNote: Classes for Microtonal Use of the FluidSynth Chugin

Soundfonts are collections of audio samples bundled together in a format that facilitates the emulation of real instruments by having samples of different pitches and velocities grouped together such that when a given note is triggered (typically by a MIDI signal) the best sample is chosen. This is especially nice for instruments like piano, where the tone color of a note varies significantly with the pitch.

[FluidSynth](http://www.fluidsynth.org/) is a software synthesizer which plays soundfonts. The main functionality of FluidSynth lives in the `libfluidsynth` library, which has been incorporated into a number of different music software projects. For ChucK, there is a FluidSynth [chugin](https://github.com/ccrma/chugins).

The libfluidsynth library is capable of supporting different tunings with an API which closely follows the [MIDI tuning standard](https://en.wikipedia.org/wiki/MIDI_tuning_standard). Some time ago, I extended the FluidSynth chugin to support this feature. I wrote a sample program using the [FluidR3_GM.sf2](https://member.keymusician.com/Member/FluidR3_GM/index.html) soundfont, and everything seemed to work fine. Later, when I tried to work with more elaborate soundfonts (such as those from the [Nice Keys](https://sites.google.com/site/soundfonts4u/) collection), I found out that I couldn't just arbitrarily assign _any_ pitch to _any_ MIDI note number and get a decent sound (or sometimes even any sound at all).

[It turns out](https://lists.nongnu.org/archive/html/fluid-dev/2020-01/msg00024.html) that, the way libfluidsynth tuning works, the sample for the assigned-to note number is retuned to the pitch to which it is assigned, instead of using a sample which meant to be close to the desired pitch. This means that, while we might get some interesting effects by tuning a note number to a pitch far from its standard tuning, we really need to use a note number close to our desired pitch to get a sound close to what the soundfont creator intended.

This is the problem which has led me to write this system of three classes: FluidEngine, FluidInstrument, and FluidNote.

* FluidEngine is a wrapper around the FluidSynth chugin which allocates and keeps track of FluidInstruments. It is a chubgraph which connects the wrapped FluidSynth object to its specified outlet, and must be connected to `dac` to get any sound output.

* A FluidInstrument is a collection of MIDI channels which all get set to the same preset (instrument) in the soundfont. A FluidInstrument allocates and keeps track of FluidNotes, finding and appropriate unassigned MIDI note number in any of its channels to best represent the desired pitch.

* A FluidNote is a note of a specified pitch, whose MIDI note number and channel were assigned by the FluidInstrument which created it, and which we do not need to know. It's up to the user of these classes to organize the FluidNotes they create in some manner that makes sense for their own project.

Due to a limitation in the way ChucK classes work (or perhaps just a limitation in my understanding of how to use them), references between these classes point in only one direction: a FluidEngine knows about the FluidInstruments it has allocted, but a FluidInstrument cannot contain a reference to the FluidEngine that created it. Fortunately, they can all contain a reference to the FluidSynth object which they all depend on; as a chugin, this is known to the compiler before any user-defined classes are created. The classes must be included in the order shown in the [`fluidnote-example.ck`](fluidnote-example.ck): first FluidNote, then FluidInstrument (which needs to know about the FluidNote class), then finally FluidEngine (which needs to know about the FluidInstrument class).

## Methods

### FluidEngine

* `void init(string soundFontPath)`: Once created, you must call `init` on the FluidEngine, specifying the path to a soundfont. This loads the soundfont and connects the wrapped FluidSynth to the FluidEngine's outlet.

* `FluidInstrument createFluidInstrument(int channelCount, int bank, int program)`: This factory method returns a FluidInstrument. The number of MIDI channels to reserve, and the bank and program of the soundfont to use must be provided. If the creation of this FluidInstrument would exceed the 16 MIDI channels available for all instruments created by this engine, the ChucK VM will crash with an error message.

* `void destroyInstrument(FluidInstrument inst)`: While this method will delete the reference to the FluidInstrument that this FluidEngine has, it doesn't free up any MIDI channels. (That would be pretty hard to do if an instrument other than the last one created was deleted.) Maybe one day it will be useful, but it's actually pretty worthless at the moment. Don't use it.

### FluidInstrument

* `FluidNote createFluidNoteCents(float cents)`: This returns a FluidNote tuned to the specified value in _absolute cents_. The underlying tuning of the FluidSynth API (and the MIDI tuning standard it's based on) uses absolute cents measured from the standard tuning of MIDI note 0. This means that the absolute cent value of a pitch is 100 times the MIDI note number of the nearest lower MIDI note number, plus how many cents it is higher than that note. As an example, since the standard A 440Hz is assigned to MIDI note number 69, a tuning of 440Hz would be 6900 cents. The FluidInstrument tries to find an appropriate MIDI note number/channel combination to assign the FluidNote to, defined as one within 200 cents of the desired pitch. If all available note number/channel combos meeting that requirement are already assigned, the ChucK VM will crash with an error message.

* `FluidNote createFluidNoteFreq(float freq)`: Returns a FluidNote tuned to the given frequency in Hz.

* `FluidNote createFluidNoteCentsDiff(FluidNote refNote, float centsDiff)`: Returns a FluidNote which is tuned `centsDiff` cents higher (or lower if negative) than the reference FluidNote `refNote`.

* `FluidNote createFluidNoteRatio(FluidNote refNote, float ratio)`: Returns a FluidNote which the frequency of the FluidNote `refNote` times the ratio `ratio`. If ratio is greater than 1, this note will be higher than the reference note; if it's less than 1, it will be lower. (If it's negative, your program will probably crash and burn in some awful way that I haven't figured out yet.)

* `void destroyFluidNote(FluidNote note)`: Removes the reference to a FluidNote from the FluidInstrument. Unlike FluidEngine's `destroyFluidInstrument`, this one is actually useful because it frees up a MIDI note number/channel combo which makes it available for new FluidNotes.

### FluidNote

* `void play(int velocity, dur length)`: This is the method that actually plays a note! It sporks a thread that sends a MIDI note on with the specified velocity, advances time by the specified duration, and then sends a MIDI note off. Note that since this is in a sporked thread, you also have to advance time in your main program for this to have an effect.
