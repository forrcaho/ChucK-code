new AdditiveSqrTri @=> AdditiveSqrTri a;
a => dac;
a.init(220.0, 0.1, 0.25);

new AdditiveSqrTri @=> AdditiveSqrTri b;
b => dac;
b.init(330.0, 0.1, 0.1875);


spork ~ a.play(12::second);
4::second => now;
spork ~ b.play(8::second);
8::second => now;
