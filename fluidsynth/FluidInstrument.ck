/*

// Temporarily uncomment this FluidNote skeleton code to make 
// syntax checking work in VSCode for this file.

class FluidNote {
    int channel;
    int noteNum;
    float cents;

    fun void init(FluidSynth synth, float cents, int channel, int noteNum){}
}

*/

public class FluidInstrument {
    FluidSynth synth;
    int instrumentIndex;   // index in parent FluidEngine's instrument array
    int channelOffset; // first (zero-based) MIDI channel of this instrument
    int channelCount;  // number of MIDI channels this instrument uses
    FluidNote @ notes[][];

    fun void init(FluidSynth synth, int instrumentIndex, 
                  int channelOffset, int channelCount,
                  int bank, int program)
    {
        synth @=> this.synth;
        instrumentIndex => this.instrumentIndex;
        channelOffset => this.channelOffset;
        channelCount => this.channelCount;
        FluidNote @ n[channelCount][128] @=> notes;
        for (channelOffset => int channel; channel < channelOffset + channelCount; channel++) {
            synth.setBank(bank, channel);
            synth.progChange(program, channel);
        }
    }

    fun FluidNote createFluidNoteCents(float cents)
    {
        FluidNote @ note;
        // First, try the closest note number
        Math.round(cents/100.0) $ int => int noteNum;
        Std.sgn( (cents/100.0) - noteNum ) $ int => int direction;
        if (direction == 0) 1 => direction;

        for (0 => int i; i < channelCount; i++) {
            if (notes[i][noteNum] == null) {
                _createFluidNote(cents, i + channelOffset, noteNum) @=> note;
                return note;
            }
        }
        // still here? Let's try the next closest note number
        direction +=> noteNum;
        for (0 => int i; i < channelCount; i++) {
            if (notes[i][noteNum] == null) {
                _createFluidNote(cents, i + channelOffset, noteNum) @=> note;
                return note;
            }
        }

        // Ok, let's try one more step back in the other direction
        (2 * direction) -=> noteNum;
        for (0 => int i; i < channelCount; i++) {
            if (notes[i][noteNum] == null) {
                _createFluidNote(cents, i + channelOffset, noteNum) @=> note;
                return note;
            }
        }

        // give up here
        <<< "Cannot assign note: ", cents, " cents" >>>;
        Machine.crash();
        return null;
    }

    fun FluidNote createFluidNoteFreq(float freq)
    {
        6900.0 + 1200.0 * (Math.log2(freq) - Math.log2(440.)) => float cents;
        return createFluidNoteCents(cents);
    }

    fun FluidNote createFluidNoteCentsDiff(FluidNote refNote, float centsDiff)
    {
        return createFluidNoteCents(refNote.cents + centsDiff);
    }

    fun FluidNote createFluidNoteRatio(FluidNote refNote, float ratio)
    {
        1200.0 * Math.log2(ratio) => float centsDiff;
        return createFluidNoteCentsDiff(refNote, centsDiff);
    }

    // creates and initializes a FluidNote once we've found where to assign it
    fun FluidNote _createFluidNote(float cents, int channel, int noteNum)
    {
        FluidNote note;
        note.init(synth, cents, channel, noteNum);
        note @=> notes[channel - channelOffset][noteNum];
        return note;
    }

    fun void destroyFluidNote(FluidNote note)
    {
        null @=> notes[note.channel][note.noteNum];
    }
}
