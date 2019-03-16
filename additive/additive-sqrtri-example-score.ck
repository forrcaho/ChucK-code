new AdditiveSqrTri @=> AdditiveSqrTri a;
a => dac;
a.init(55.0, 0.1, 0.25);

new AdditiveSqrTri @=> AdditiveSqrTri b;
b => dac;
b.init(82.5, 0.1, 0.25);


spork ~ a.play(12::second);
4::second => now;
spork ~ b.play(8::second);
8::second => now;
