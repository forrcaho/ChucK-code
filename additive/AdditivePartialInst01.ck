public class AdditivePartialInst01 extends AdditivePartial {

    dur peakLoc, switchEnvLoc, susLoc;
    float peakAmplitude, susAmplitude, peakLocSec, susLocSec, exponent;

    fun void init( int partialNumber, float baseFreq, float noteAmplitude, 
                   dur basePeakLoc, dur susLoc, int numPartials)
    {
        this.init(partialNumber, baseFreq, noteAmplitude);
        basePeakLoc / Math.sqrt(partialNumber) => peakLoc;
        noteAmplitude * Math.pow(partialNumber, -(2.0 * (partialNumber-1.0)/numPartials)) => peakAmplitude;
        noteAmplitude * Math.pow(partialNumber, -2.0) => susAmplitude;
        peakLoc/1::second => peakLocSec;
        susLoc/1::second => susLocSec;
        Math.pow(susAmplitude/peakAmplitude, 1.0/(susLocSec - peakLocSec)) => exponent;
    
        // This will work well when susLoc >> 2*peakLoc, otherwise, maaaybe not.
        peakLoc => switchEnvLoc;
        for (peakLoc => dur loc; loc <= 2*peakLoc; controlDur() +=> loc) {
            if (env2(loc, susLoc) > env1(loc, susLoc)) {
                loc => switchEnvLoc;
                break;
            }
        }
    }

    fun dur controlDur()
    {
        return 16::samp;
    }

    fun float env1( dur timeLoc, dur duration )
    {
        peakAmplitude * Math.sin(0.5 * Math.PI * (duration/peakLoc)) => float env;
        return env;
    }

    fun float env2( dur timeLoc, dur duration ) {
        timeLoc/1::second => float timeLocSec;
        peakAmplitude * Math.pow(exponent, timeLocSec - peakLocSec) => float env;
        return env;
    }

    fun float partialAmplitude( dur timeLoc, dur duration )
    {
        0 => float env;
        if ( timeLoc < switchEnvLoc ) {
            env1(timeLoc, duration) => env;
        }
        else if ( timeLoc < susLoc ) {
            env2(timeLoc, duration) => env;
        }
        else {
            susAmplitude => env;
        }
        0.2::second => dur fade;
        if (timeLoc > (duration - fade)) {
            (duration - timeLoc)/fade *=> env;
        }
        return env;
    }
}