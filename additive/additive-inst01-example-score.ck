new AdditiveInst01 @=> AdditiveInst01 a;
a => dac;
a.init(110.0, 0.1, 1.6::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 b;
b => dac;
b.init(137.5, 0.1, 0.8::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 c;
c => dac;
c.init(165.0, 0.1, 0.4::second, 3::second);

new AdditiveInst01 @=> AdditiveInst01 d;
d => dac;
d.init(192.5, 0.1, 0.2::second, 3::second);


spork ~ a.play(5.6::second);
0.7::second => now;
spork ~ b.play(4.9::second);
0.7::second => now;
spork ~ c.play(4.2::second);
0.7::second => now;
spork ~ d.play(3.5::second);

3.5::second => now;
