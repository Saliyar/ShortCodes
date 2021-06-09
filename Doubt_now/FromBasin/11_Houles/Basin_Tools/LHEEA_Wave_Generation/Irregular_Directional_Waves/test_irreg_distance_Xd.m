function test_irreg_distance_Xd

global spectra_names
spectra_names.jonswap = {'JONSWAP', 'jonswap', 'Jonswap'};
spectra_names.bretsch = {'bretsch', 'Bretschneider', 'bretschneider'};
spectra_names.error   = ': Unknown spectrum. Check spelling and spectra_names variable';

% Repeat period
rnum = 12; % with corresponding repeat period 12=128s, 14=512s, 15=1024s, 16=2048s, 17=4096s
T_repeat = pow2(rnum-5);
% frequency range
freq_range = [0,2]; % Hz
% harmonic object
harmo = floor(freq_range*T_repeat); % # of the wave fronts in ocean langage (frequency is harmo/T_repeat)
harmo = harmo(1):harmo(2);
% remove null frequency
harmo(harmo == 0) = [];
%
[harmo, ampli] = LHEEA_build_ampli(1, harmo, T_repeat, 0.1, 2, 'JONSWAP', 3.3);
%
depth = 3; % m
freq = harmo / T_repeat;
k = wave_number(freq, depth);
cg = group_velocity(freq, k, depth);
% target distance
Xd = 60; % m
% random phases
phase = 2*pi*rand(size(harmo));
%
[t_arrival, harmo_test, ampli_test, phase_test] = LHEEA_delayed_generation(harmo, ampli, phase, T_repeat, depth, Xd);
t_arrival
% slow arrival time
t_slow = Xd/cg(end);
% time vector
t = 0:1/16:T_repeat;
% initialization
eta = zeros(size(t));
eta_old = zeros(size(t));
eta_test = zeros(size(t));
for n=1:length(harmo)
    delay = zeros(size(t));
    delay(t > t_slow - Xd/cg(n)) = 1;
    sine_wave = ampli(n) .* cos(2*pi*freq(n)*t+phase(n));
    eta = eta + delay .* sine_wave;
    eta_old = eta_old + sine_wave;
end
freq_test = harmo_test / T_repeat;
for n=1:length(harmo_test)
    sine_wave = ampli_test(n) .* cos(2*pi*freq_test(n)*t+phase_test(n));
    eta_test = eta_test + sine_wave;
end
figure(11), clf
plot(t,eta, t, eta_old, t, eta_test)
add_vertical(t_slow-Xd/cg(1));
