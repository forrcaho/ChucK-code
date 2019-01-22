public class Additive extends Chubgraph {

    float baseFreq;
    float noteAmplitude;
    AdditivePartial @ partial[numPartials()];

    fun int numPartials() { return 25; }

    fun AdditivePartial initPartial(int partialNumber)
    {
        new AdditivePartial @=> AdditivePartial ap;
        ap.init(partialNumber, baseFreq, noteAmplitude);
        ap => outlet;
        return ap;
    }

    fun void play(dur duration)
    {
        for(0 => int i; i < numPartials(); i++) {
            spork ~ partial[i].play(duration);
        }
        duration => now;
    }

    fun void init(float baseFreq, float noteAmplitude)
    {
        baseFreq => this.baseFreq;
        noteAmplitude => this.noteAmplitude;
        for (0 => int i; i < numPartials(); i++) {
            initPartial(i+1) @=> partial[i];
        }
    }
}

