FluidEngine engine => dac;
engine.init("/usr/local/share/sounds/sf2/Nice-Keys-Ultimate-V2.3.sf2");

FluidInstrument @ elecPiano;
engine.createFluidInstrument(3, 0, 17) @=> elecPiano; // 3 MIDI channels, bank 0 preset 17

elecPiano.createFluidNoteCents(6000) @=> FluidNote @ tonic;
tonic.play(100, 4::second);
0.5::second => now;
elecPiano.createFluidNoteRatio(tonic, 5./4.) @=> FluidNote @ third;
third.play(100, 3.5::second);
0.5::second => now;
elecPiano.createFluidNoteRatio(tonic, 3./2.) @=> FluidNote @ fifth;
fifth.play(100, 3::second);
0.5::second => now;
elecPiano.createFluidNoteRatio(tonic, 7./4.) @=> FluidNote @ nat7th;
nat7th.play(100, 2.5::second);


3::second => now;

