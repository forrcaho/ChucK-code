public class AdditiveSqrTri extends Additive {
    float detune;

    fun AdditivePartial initPartial(int partialNumber)
    {
        new AdditivePartialSqrTri @=> AdditivePartialSqrTri apst;
        apst.init(partialNumber, baseFreq, noteAmplitude, detune);
        apst => outlet;
        return apst;
    }

    fun void init(float baseFreq, float noteAmplitude, float detune)
    {
        detune => this.detune;
        init(baseFreq, noteAmplitude);
    }
}