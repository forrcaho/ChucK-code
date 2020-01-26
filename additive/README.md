# Class-based Additive Sythesis in ChucK

Here is a class-based implementation of additive synthesis in ChucK which
should be easy to adapt.

`Additive` is a base class which contains an array of partials, each of
which is implmented by the `AdditivePartial` base class.

Since abstract classes do not exist in ChucK, these base classes implement a
simple sawtooth wave. The file `chuck additive-base-example.ck` contains an
example of how it can be used.

There are two examples of new additive instruments created by extending the
base classes:

* `AdditiveInst01` is designed to give a bright attack by having higher
partials peak earlier than lower ones. The (no doubt needlessly complex)
amplitude envelope consists of a sinusoidal attack, followed by an exponential
decay section down to a sustain level held until the end of the note.

* `AdditiveSqrTri` uses only odd harmonics, with a slight detuning between
alternate harmonics that causes the waveform to alternate between a square and
a triangle wave.
