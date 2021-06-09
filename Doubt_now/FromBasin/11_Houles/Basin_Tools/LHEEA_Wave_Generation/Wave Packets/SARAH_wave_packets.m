function SARAH_packets(wave_basin,path_out, file_name, f_0_target, H, t_start, N_periods, T_ramp_s,multiplier_linear,multiplier_nonlinear,N_packets,rnum )
if nargin==0
    
    % Wave characteristics
    wave_basin = 'ECN_wave'; % among 'ECN_wave', 'ECN_towing', or 'ECN_small'
    % put path
    path_out = 'D:\ownCloudData\Projets_2017\1709_SARAH\02_Expérimentation\wmk\packets\';
    file_name = 'SARAH_wave_packets_04';
    
    f_0_target = 0.306; % Hz
    H = 0.94*0.9847; % m % Adjust at 0.515 m and not 0.523
    
    t_start = 10;
    N_periods = 10;
    T_ramp_s =  3;
    
    
    
    %% Wavemaker correction
    multiplier_linear = 1.10; % linear wavemaker transfer function correction (gain)
    multiplier_nonlinear = 1; % nonlinear wavemaker transfer function  (induced by steepness)
    
    N_packets = 1;
    rnum = 12;
    % 13 = 256 s
    % 14 = 512 s
    % 15 = 1024 s = 1 mHz
    % 16 = 2048 s = 0.5 mHz
    % 17 = 4096 s = 0.24 mHz
    % 18 = 8192 s = 0.12 mHz
    
end

rmpath('C:\Program Files\MATLAB\R2016a\toolbox\symbolic\symbolic'); % Use in case of prob with harmonic
rmpath('C:\Program Files\MATLAB\R2018b\toolbox\symbolic\symbolic');
fontsize = 12;

file_path  = [path_out 'ocean\' file_name '\']; % path relative to the current routine's path where the .wav file will be stored
prepare_ocean_folder(file_path);

%% Parameters
% wavemaker
wmk = wavemaker(wave_basin);
depth = get(wmk,'depth');
%
f_samp = 64; % Hz
%
% Time vector
T_repeat = calc_T_repeat(rnum);
f_0 = floor(T_repeat*f_0_target)/T_repeat;
display([' target frequency was ' num2str(f_0_target)]);
display([' realized frequency is ' num2str(f_0)]);
% Wave characteristics
% angular frequency and wavenumber
omega_0 = 2*pi*f_0;
k_0 = wave_number(f_0, depth);


% ramp
N_start = floor(t_start * f_samp);
N_stop = floor((t_start + N_periods/f_0) * f_samp);
T_ramp = T_ramp_s / f_0;

N_ramp = floor(T_ramp * f_samp);
ramp = (1:N_ramp)/N_ramp;

N_repeat = T_repeat * f_samp;
epsilon = k_0 * H/2 * ones(1,N_packets);


% Construct eta_lin 
time = (0:(floor(f_samp*T_repeat)-1))/f_samp;
eta_lin = zeros(length(time),1);


% figure(100), clf, hold all

figure(1), clf, subplot(3,1,1), hold all
ax(1) = subplot(3,2,[3,5]); hold all
ax(2) = subplot(3,2,[4,6]); hold all
% construction of each packet
for n = 1:N_packets
    a = epsilon(n) / k_0;
    %
    phase = omega_0 * time;
    envelope = ones(size(time));
    envelope(1:N_start) = 0;
    envelope(N_stop:end) = 0;
    envelope(N_start + (1:N_ramp)) = ramp;
    envelope(N_stop-N_ramp+(1:N_ramp)) = fliplr(ramp);
    packet = real(envelope * a .* exp(1i*phase));
    eta_lin(1:N_repeat) = eta_lin(1:N_repeat) + packet.';
    [ampli, freq] = Fourier(packet, f_samp);
    
    
    figure(1)
    subplot(3,1,1), plot(time, packet), plot(time, a*envelope), set(gca, 'ColorOrderIndex', 2), plot(time, - a*envelope)
    subplot(3,2,[3,5]), hold all, plot(freq, abs(ampli)), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Amplitude (m)')
    subplot(3,2,[4,6]), plot(freq, unwrap(angle(ampli))), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Phase (rad)')
end
drawnow
linkaxes(ax,'x')
subplot(3,2,[4,6]), xlim([0,2])
subplot(3,1,1), SARAH_finish_plot(fontsize, 'Time (s)', 'Wave (m)')
subplot(3,2,[3,5]), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Amplitude (m)')
subplot(3,2,[4,6]), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Phase (rad)')
%
[ampli, freq] = Fourier(eta_lin(1:N_repeat,1), f_samp);
eta_lin_hat = hilbert(eta_lin(1:N_repeat,1));
phase = unwrap(atan2(imag(eta_lin_hat), eta_lin(1:N_repeat,1))) - 2*pi*f_0*time.';
envelope = sqrt(eta_lin(1:N_repeat,1).^2+imag(eta_lin_hat).^2) .* exp(1i*phase);

plotWavePacket(time,eta_lin,N_repeat,T_repeat, envelope, freq,ampli);


% ocean's files we just need eta
SARAH_wave_packets_ocean(1, T_repeat, f_samp, eta_lin, file_path, file_name, wave_basin, multiplier_linear,multiplier_nonlinear )
