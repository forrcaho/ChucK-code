new Additive @=> Additive a;
a => dac;
a.init(220.0, 0.1);

new Additive @=> Additive b;
b => dac;
b.init(275.0, 0.1);

spork ~ a.play(2::second);
0.5::second => now;
spork ~ b.play(2::second);

2::second => now;
