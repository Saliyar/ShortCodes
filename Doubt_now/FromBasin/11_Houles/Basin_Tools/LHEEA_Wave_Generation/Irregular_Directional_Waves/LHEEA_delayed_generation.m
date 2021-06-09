function [t_arrival, harmo_out, ampli_out, phase_out] = LHEEA_delayed_generation(harmo, ampli, phase, T_repeat, depth, target_location)
% use target location generation (1D correct)

if target_location == 0
    t_arrival = 0;
    harmo_out = harmo;
    ampli_out = ampli;
    phase_out = phase;
else
    % wave components
    %   frequency f_n = n Delta f
    freq = harmo / T_repeat;
    %   wavenumber
    k = wave_number(freq, depth);
    %   group velocity
    cg = group_velocity(freq, k, depth);
    % slow arrival time
    t_slow = target_location / min(cg);
    % arrival time
    t_arrival = t_slow;
    if t_arrival > T_repeat/8
        warning('Arrival time of the slowest wave bigger than T_repeat/8. You may want to think about increasing T_repeat')
    end
    % time vector
    f_samp = 32; % 32 Hz sampling frequency
    N_repeat = floor(T_repeat*f_samp);
    t = (0:N_repeat-1)/f_samp;
    % initialization
    eta = zeros(size(t));
    eta_no_delay = zeros(size(t));
    % building the delayed signal in time domain
    for n=1:length(harmo)
        delay = zeros(size(t));
        delay(t > t_slow - target_location / cg(n)) = 1;
        % wave component at wavemaker location x=0
        sine_wave = ampli(n) .* cos(2*pi*freq(n)*t+phase(n));
        % standard elevation, without delay, for comparison
        eta_no_delay = eta_no_delay + sine_wave;
%         % make sure the energy is the same in this frequency band
%         sine_wave = sine_wave * sqrt(T_repeat / (T_repeat - (t_slow - target_location / cg(n))));
        % make sure wave arrives at t_slow
        eta = eta + delay .* sine_wave;
    end
    figure(1), clf, hold all
    plot(t, eta_no_delay, t, eta)
    % back to frequency domain
    [FT, freq_FT] = Fourier(eta, f_samp);
    % selecting the new harmonics, amplitudes and phases whose frequency is below 2 Hz
    harmo_out = floor(freq_FT(freq_FT <= 2)*T_repeat);
    ampli_out = abs(FT(freq_FT <= 2));
    phase_out = angle(FT(freq_FT <= 2));
    % applying the restriction on energy
    harmo_out = harmo_out(harmo+1);
    ampli_out = ampli_out(harmo+1);
    phase_out = phase_out(harmo+1);
    freq_out = harmo_out / T_repeat;
    %
    % psd S(f) = a^2/2/Delta f
    S = ampli.^2/2*T_repeat;
    [FT_check, freq_check] = Fourier(eta(t>t_arrival), f_samp);
    ampli_check = abs(FT_check(freq_check <= 2));
    freq_check = freq_check(freq_check <= 2);
    ampli_check = ampli_check(freq_check >= min(freq) & freq_check <= max(freq));
    freq_check = freq_check(freq_check >= min(freq) & freq_check <= max(freq));
    S_check = ampli_check.^2/2*(T_repeat-t_arrival);
    % Zeroth moment (total energy)
    m_0 = trapz(freq, S);
    m_0_check = trapz(freq_check, S_check);
    disp(['Energy gain/loss = ', num2str((m_0_check-m_0)/m_0*100,2), ' % during delayed generation operation'])
    % plotting the results
    eta_out = zeros(size(t));
    for n=1:length(harmo_out)
        sine_wave = ampli_out(n) .* cos(2*pi*freq_out(n)*t+phase_out(n));
        eta_out = eta_out + sine_wave;
    end
    figure(1)
    plot(t, eta_out)
    set(gca, 'FontSize', 13)
    legend('original', 'delayed, no restriction', 'delayed & restriction')
    xlabel('Time (s)')
    ylabel('Elevation (m)')
    %
    figure(2), clf
    subplot(1,2,1)
    set(gca, 'FontSize', 13)
    plot(freq, ampli, freq_FT, abs(FT), harmo_out/T_repeat, ampli_out)
    xlim([0,2])
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (m)')
    subplot(1,2,2)
    set(gca, 'FontSize', 13)
    plot(freq, angle(exp(1i*phase)), freq_FT, angle(FT), harmo_out/T_repeat, phase_out)
    xlim([0,2])
    xlabel('Frequency (Hz)')
    ylabel('Phase (rad)')
    legend('original', 'delayed, no restriction', 'delayed & restriction')
end