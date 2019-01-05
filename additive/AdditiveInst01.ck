public class AdditiveInst01 extends Additive {

    dur peakLoc, susLoc;


    fun AdditivePartial initPartial(int partialNumber)
    {
        new AdditivePartialInst01 @=> AdditivePartialInst01 api01;
        api01.init(partialNumber, baseFreq, noteAmplitude, peakLoc, susLoc, numPartials());
        api01 => outlet;
        return api01;
    }

    fun void init(float baseFreq, float noteAmplitude, dur peakLoc, dur susLoc) 
    {
        peakLoc => this.peakLoc;
        susLoc => this.susLoc;
        this.init(baseFreq, noteAmplitude);
    }
}