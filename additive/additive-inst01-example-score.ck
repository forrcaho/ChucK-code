new AdditiveInst01 @=> AdditiveInst01 a;
a => dac;
a.init(220.0, 0.1, 0.8::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 b;
b => dac;
b.init(275.0, 0.1, 0.6::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 c;
c => dac;
c.init(330.0, 0.1, 0.4::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 d;
d => dac;
d.init(385.0, 0.1, 0.2::second, 3::second);


spork ~ a.play(5.5::second);
0.5::second => now;
spork ~ b.play(5::second);
0.5::second => now;
spork ~ c.play(4.5::second);
0.5::second => now;
spork ~ d.play(4::second);

4::second => now;
