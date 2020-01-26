/*

// Temporarily uncomment this FluidInstrument skeleton code to make 
// syntax checking work in VSCode for this file.

class FluidInstrument {
    int instrumentIndex;   // index in parent FluidEngine's instrument array
    int channelCount;  // number of MIDI channels this instrument uses
    int channelOffset; // first (zero-based) MIDI channel of this instrument

    fun void init(FluidSynth synth, int instrumentIndex, 
                  int channelOffset, int channelCount,
                  int bank, int program) {};
}

*/

public class FluidEngine extends Chubgraph {

    FluidSynth synth;
    FluidInstrument @ instruments[16]; // max possible instruments; one per MIDI channel
    0 => int minUnassignedChannel;
    0 => int nextInstrumentIndex;
    string soundFontPath;

    fun void init(string soundFontPath) {
        soundFontPath => this.soundFontPath;
        synth.open(soundFontPath);
        synth => outlet;
    }

    fun FluidInstrument createFluidInstrument(int channelCount, int bank, int program)
    {
        if (minUnassignedChannel + channelCount > 16) {
            // you ran out of channels!
            <<< "Instrument would exceed available MIDI channels" >>>;
            Machine.crash();
        }
        FluidInstrument inst;
        inst.init(synth, nextInstrumentIndex, minUnassignedChannel, channelCount, bank, program);
        inst.channelOffset + inst.channelCount => minUnassignedChannel;
        inst @=> instruments[inst.instrumentIndex];
        nextInstrumentIndex++;
        <<< "created instrument", "" >>>;
        return inst;
    }

    fun void destroyInstrument(FluidInstrument inst)
    {
        // Here we just delete the instrument from the Engine's index.
        // Real cleanup would free MIDI channels, but that's hard
        null @=> instruments[inst.instrumentIndex];
    }
}