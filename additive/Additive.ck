public class Additive {

    float baseFreq;
    float noteAmplitude;
    AdditivePartial @ partial[numPartials()];

    fun int numPartials() { return 20; }

    fun void initPartials(float baseFreq, float noteAmplitude)
    {
        for (0 => int i; i < numPartials(); i++) {
            AdditivePartial.init(i+1, baseFreq, noteAmplitude) @=> partial[i];
        }
    }

    fun void play(dur duration)
    {
        for(0 => int i; i < numPartials(); i++) {
            spork ~ partial[i].play(duration);
        }
        duration => now;
    }

    fun static Additive init(float baseFreq, float noteAmplitude)
    {
        new Additive @=> Additive a;
        baseFreq => a.baseFreq;
        noteAmplitude => a.noteAmplitude;
        a.initPartials(baseFreq, noteAmplitude);
        return a;
    }
}

