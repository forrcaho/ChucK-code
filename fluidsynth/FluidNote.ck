public class FluidNote {
    FluidSynth synth;
    float cents;
    int channel;
    int noteNum;

    fun void init(FluidSynth synth, float cents, int channel, int noteNum){
        synth @=> this.synth;
        cents => this.cents;
        channel => this.channel;
        noteNum => this.noteNum;
        synth.tuneNote(noteNum, cents, channel);
    }

    fun void play(int velocity, dur length)
    {
        spork ~ _play(velocity, length);
    }

    fun void _play(int velocity, dur length)
    {
        synth.noteOn(noteNum, velocity, channel);
        length => now;
        synth.noteOff(noteNum, channel);
    }
}