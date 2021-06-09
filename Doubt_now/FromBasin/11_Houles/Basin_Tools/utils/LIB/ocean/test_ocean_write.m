r_num = 17; % 17=4096s
T_repeat = pow2(r_num-5);
% harmonic object
harmo = harmonic(floor(T_repeat * 0.5),1,[],10);
% wavemaker
wmk = wavemaker('ECN_wave');
depth = get(wmk,'depth');
% wavemaker control law
X_d = 10;
c_law = control_law(0, 'dalrymple', X_d, 1);
% wave object
wv = wave(T_repeat, 16, harmo, wmk, c_law);
%
% .wav file
file = 'test_wave';
ocean_wave2wavfile(wv, file, 'This is a title', 'nameoftheroutine', 'Run title', 'nantes_main_posn/default.ttf');
