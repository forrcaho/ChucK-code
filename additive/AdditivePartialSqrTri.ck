public class AdditivePartialSqrTri extends AdditivePartial {

    float detune;

    fun void init( int partialNumber, float baseFreq, float noteAmplitude, float detune )
    {
        this.init(partialNumber, baseFreq, noteAmplitude);
        detune => this.detune;
    }

    fun float partialFrequency(dur timeLoc, dur duration )
    {
        baseFreq * (2*partialNumber - 1) => float f;
        if (partialNumber % 2 == 0) {
            detune -=> f;
        } else {
            detune +=> f;
        }
        return f;
    }

}
