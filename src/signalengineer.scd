//Server
Server.local.boot;
Server.local.quit;
s.boot;
s.quit;

//Experiment----Audio_Spell
x = {
	SinOsc.ar //sinewavetableoscillator
    };
y = x.play;
y.free;

a = {
	SinOsc.ar(100, 1, 0.5, 0) //freq, phase,mull, add
    }.play;
a.free;

(
z = {
	arg freq= 220, amp= 1;
	var test;
	test= SinOsc.ar(freq) * amp;
    }.play;
)
z.set(\freq,150);
z.set(\amp, 0.5);
z.set(\freq, 25, \amp, 2);
z.free;

(
k = {
	var freq, sig;
	freq = LFNoise0.kr(2,200,100);
	sig = SinOsc.ar(freq);
    }.play;
)
k.free;

(
w = {
	arg noiseHz = 5;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).range(200,100);
	amp = LFNoise1.kr(2).exprange(50,200);
	sig = SinOsc.ar(freq) * amp;
    }.play;
)

w.set(\noiseHz, 8);
w.free;

(//New instance w 2/6 args
SynthDef.new(\sineTest, {
	arg noiseHz = 2;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(90,40);
	amp = LFNoise1.kr(10).exprange(0.5,2);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0,sig);
	}).add;
)

t = Synth.new(\sineTest, [\noiseHz, 6]);
t.set(\noiseHz,20);
t.free;

(
SynthDef.new(\pulseTest, {
	arg ampHz= 9, fund=70, maxPartial=2, width=0.3;
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 1, 0) * 0.5 ;
	amp2 = LFPulse.kr(ampHz, 3, 2) * 0.4 ;
	freq1 = LFNoise0.kr(2).exprange(fund, fund * maxPartial).round(fund);
	freq2 = LFNoise0.kr(2).exprange(fund, fund * maxPartial).round(fund);
	freq1 = freq1 * LFPulse.kr(4, add:1);
	freq2 = freq2 * LFPulse.kr(1.5, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp2);
	sig1 = FreeVerb.ar(sig1, 0.6, 0.2, 0.1);
	sig2 = FreeVerb.ar(sig2, 0.6, 0.2, 0.1);
	Out.ar(0,sig1); //left speaker
	Out.ar(1,sig2); //right speaker
}).add;
)

q = Synth.new(\pulseTest);
q.set(\width, 0.5);
q.set(\fund, 12);
q.set(\maxPartial, 4);
q.set(\ampHz, 3);

q = Synth.new(\pulseTest, [\width, 0.2, \fund, 50]);
q.free;



