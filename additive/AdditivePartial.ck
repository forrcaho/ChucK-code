public class AdditivePartial extends SinOsc {

    /*
    Set a MAX_FREQUENCY value that's just below the Nyquist rate.
    We will drop partials that start higher than this, and set gain
    to zero if it's exceeded during a partial sounding.
    */
    (1::second/1::samp) * 0.499 => float MAX_FREQUENCY;

    int partialNumber;
    float baseFreq;
    float noteAmplitude;

    fun void init( int partialNumber, float baseFreq, float noteAmplitude ) 
    {
        partialNumber => this.partialNumber;
        baseFreq => this.baseFreq;
        noteAmplitude => this.noteAmplitude;
        // be silent until play() is called
        0 => this.gain;
        0 => this.freq;
    }

    /*
    Control step duration. Duration to play before adjusting aplitude & frequency for each partial.
    A setting of 1::samp can easily use too much compute power and lead to glitches.
    */
    fun dur controlDur()
    {
        return 16::samp;
    }

    /*
    The relative amplitude of the Nth partial, in a range from 0 to 1. Note that even though 
    noteAmplitude (the gain for the entire composite note) is passed in, we don't scale by that value
    here. That is just provided so that louder notes can have a different timbre than quieter
    ones (e.g. be brighter).

    The default here gives the nth partial an ampitude of 1/2*n^2 with a small attack and decay to avoid glitches.
    */
    fun float partialAmplitude( dur timeLoc, dur duration )
    {
        0.5 * Math.pow(partialNumber, -2.0) => float maxGain;
        0.1::second => dur fadeTime;
        if (timeLoc < fadeTime) {
            return maxGain * (timeLoc/fadeTime);
        }
        if (timeLoc > (duration - fadeTime)) {
            return maxGain * ((duration - timeLoc)/fadeTime);
        }
        return maxGain;
    }

    /*
    The frequency of the Nth partial, in Hz. The calling routine is responsible for filtering out
    fequencies greater than the Nyquist frequency, so we don't need to worry about that here. Note,
    though, that if a partial starts below the Nyquist frequency and then exceeds it, the gain will
    suddenly drop to zero, which may cause glitches. (Partials which would start above the Nyquist
    are skipped entirely.)

    This base function returns the most common n * the base frequency for the nth partial. 
    */
    fun float partialFrequency(dur timeLoc, dur duration )
    {
        return baseFreq * partialNumber;
    }

    /*
    This routine is sporked for each partial. It does not spork any partial that starts above MAX_FREQUENCY,
    and drops any partial that exeeds MAX_FREQUENCY after it's started down to zero gain (which will only happen
    when partialFrequency is overridden using a time-varying function that ascends above its starting value).

    This method is not intended to be overridden.
    */
    fun void play( dur duration )
    {
        controlDur() => dur step;
        now => time start;
        now - start => dur timeLoc;
        while (timeLoc < duration) {
            this.partialFrequency(timeLoc, duration) => float frequency;
            if (frequency < MAX_FREQUENCY) {
                frequency => this.freq;
                noteAmplitude * partialAmplitude(timeLoc, duration) => this.gain;
            } else {
                0 => this.gain;
            }
            step => now;
            now - start => timeLoc;
        }
        // return to silence now that play() is complete
        0 => this.gain;
        0 => this.freq;
    }
}