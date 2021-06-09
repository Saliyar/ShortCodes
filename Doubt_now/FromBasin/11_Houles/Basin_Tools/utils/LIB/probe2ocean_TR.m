%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Transform probe signal into
% ocean files for experiments
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [time2,out_wmk,out_eta,freq,out_FT_wmk,out_FT_eta] = probe2ocean_TR(filename_ocean,time,data,xprob,amp,type_wmk,f_min,f_max,Correc_2nd,Correc_free)

if nargin < 4
    error('not enough input arguments')
end
if nargin < 5
    type_wmk = 'ECN_towing';
end
if nargin < 6
    f_min = 0;
end
if nargin < 7
    f_max = 2;
end
if nargin < 8
    Correc_2nd = false;
end
if nargin < 9
    Correc_free = false;
end
%
%% Create output of ocean file
% Experiment title, will appear in wavemaker GUI
title = strcat('Time Reversal - Refocusing',' , Amplitude =', num2str(amp*100), '%');
routine = mfilename; % for reference in the .wav files
%
if strcmp(type_wmk,'ECN_towing')
    fid     = ocean_write_header(filename_ocean, title, routine, 'nantes_towing/towing_h2p9_2.ttf');
    fid_sum = ocean_write_summary_header(filename_ocean, title, routine, 'nantes_towing/towing_h2p9_2.ttf');
else
    error('specify correct ttf for wave basin...')
    fid     = ocean_write_header(filename_ocean, title, routine, '???.ttf');
    fid_sum = ocean_write_summary_header(filename_ocean, title, routine, '???.ttf');
end
%
% Define wavemaker type
%wmk = wavemaker(type_wmk); %use of predefined wmk type
if strcmp(type_wmk,'ECN_towing')
    % New towing tank...
    wmk = wavemaker(2.9, 'hinged', 0.48, [], 1, 3, [], []);
else
    wmk = wavemaker(type_wmk); %use of predefined wmk type
end
%
clock_rate = 32;
%
% input data
time = time;
for i1=1:length(xprob)
    X    = data(:,i1);
    %
    if Correc_2nd
        eta_2nd = zeros(size(X));
        N_iter  = 30;
        disp_fig = true;
        %N_max = floor((reprod.f_max * reprod.T_repeat)/2+1);% GD 2015
        if disp_fig
            figure(i1*100+55),clf,bx(1) = subplot(2,1,1);hold all,bx(2) = subplot(2,1,2);hold all
            linkaxes(bx,'x')
            figure(i1*100+56),clf,cx(1) = subplot(2,1,1);hold all,cx(2) = subplot(2,1,2);hold all
            linkaxes(cx,'x')
        end
        for n=1:N_iter
            disp(['N_iter = ' num2str(n) ' on ' num2str(N_iter) ' iterations'])
            % Fourier transform of the linearized signal
            [FT,freq] = Fourier((X - eta_2nd), 1/(time(2)-time(1)));
            % Restricting the frequency range
            %FT([1,N_max+1:end]) = 0;
            FT(freq>f_max)=0;
%             FT(freq>f_max)=[];
%             freq(freq>f_max)=[];
%             warning('change to validate in Dalzell treatment...')
            %% ramp on the very low frequencies
            %FT(freq <= reprod.f_ramp) = ramp.' .* FT(freq <= reprod.f_ramp);
            % Dalzell solution
            [eta_1st, eta_2nd, a_2] = Dalzell_Fourier(FT.', freq, time, get(wmk,'depth'), 1/(time(2)-time(1))); %GD 2015, Dalzell Fourier uses half the spectrum (i.e. output of Fourier)
            % Displaying iteration results
            if disp_fig
                figure(i1*100+55) % Fourier domain
                axes(bx(1)), plot(freq, abs(FT).')
                axes(bx(2)), plot(freq(1:min(length(a_2),length(freq))), abs(a_2(1:min(length(a_2),length(freq)))).')
                xlim([0 f_max])
                figure(i1*100+56) % Time domain
                axes(cx(1)), plot(time, eta_1st)
                axes(cx(2)), plot(time, eta_2nd)
                xlim([0 time(end)])
            end
        end
        %
        X = eta_1st;
        clear eta_1st
    end
    %
    n_t   = length(time);
    t_min = time(1);
    t_max = time(n_t);
    T_d   = t_max - t_min;
    %
    % Analysis
    %rnumb = nextpow2(clock_rate * T_d)+1;%+1 is to ensure that it is sufficiently long
    rnumb = nextpow2(clock_rate * 255);%to ensure that Trepeat=256s
    n_fft = pow2(nextpow2(n_t * 255 / T_d));
    T_e   = pow2(rnumb) / clock_rate;
    d_t   = T_e / n_fft;
    n_d   = floor(T_d / d_t);
    %
    % 
    X2 = interp1(time, X, ((0:n_d-1)*d_t));
%     %
%     % To check interpolation
%     figure;
%     plot(time,X,(0:n_d-1)*d_t,X2,'ro')
    %
    Fwm  = 2*fft(X2, n_fft) / n_fft;
    % 0th component is not multiplied by 2
    Fwm(:,1) = Fwm(:,1)/2;
    wm       = 2*pi * (1:n_fft) / T_e;
    % store
    Fwm_init = Fwm;
    %
    % Apply frequency cut-off
    Fwm(:,wm/(2*pi)<f_min) = 0;
    Fwm(:,wm/(2*pi)>f_max) = 0;
%     %
%     % To check fourier transform
%     figure;
%     subplot(1,2,1)
%     plot(wm/(2*pi),abs(Fwm))
%     subplot(1,2,2)
%     plot(wm/(2*pi),angle(Fwm))
    %
    f_samp = clock_rate / pow2(rnumb);
    %
    % Possibly include here a cutoff frequency...
    n_cut = n_fft / 2;
    %
    harmo = [];
    frequ = [];
    ampli = [];
    angl  = [];
    phase = [];
    % case m=0
    m=0;
    %freq = m * f_samp;

    harmo = [harmo m];
    %frequ = [frequ freq];
    ampli = [ampli abs(Fwm(m+1))];
    angl  = [angl  0.0];
    phase = [phase angle(Fwm(m+1))];
    for m = 1:n_cut
        %freq = m * f_samp;
        harmo = [harmo m];
        %frequ = [frequ freq];
        ampli = [ampli abs(Fwm(m+1))];
        angl  = [angl  0.0];
        phase = [phase angle(Fwm(m+1))];
    end
    %
    % Remove too small amplitudes
    ind   = find(ampli < 0.005 * max(ampli));
    harmo(ind) = [];
    ampli(ind) = [];
    phase(ind) = [];
    angl(ind)  = [];
    %
    harmo2 = harmonic(harmo, ampli, phase, angl);
    % wave object
    wv     = wave(T_e, f_samp, harmo2, wmk);%T_e is T_repeat
    %
    % Remove free waves from wavemaker
    %
    if (Correc_free)
        wv_free = eval_free_waves(wv, 60);
        % to ensure values are exactly the same!
        wv_free=set(wv_free,'depth',get(wv,'depth'));
        wv_free=set(wv_free,'Ly',get(wv,'Ly'));
        %
        wv      = wv + phase_shift(wv_free,pi);
    end
    %
    %filename_export = [filename_ocean '_' num2str(i1)];
    filename_export = [filename_ocean '_' num2str(i1)];
    % % creating output file for HOS-NWT
    export(wv,'all',filename_export)
    %
    [pathstr, name_short, ext] = fileparts(filename_export);
    name_short = strcat(name_short, ext); %to prevent possible problems if name contains .
    %
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, i1, wv);
    %N_2000 = export(wv, 'ocean', filename_export);
    N_2000 = export(wv, 'ocean_correction_TF', filename_export);
    %
    %% output of ocean file
    ocean_write_data_read(fid, name_short, i1, N_2000);
    % following useful for computations
    export(wv, 'cfg', filename_export);
end
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
for i1=1:length(xprob)
    run = strcat('Time Reversal, x_probe = ', num2str(xprob(i1)), ' m');
    ocean_write_run(fid, run, rnumb, i1);
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check the wavemaker motion
depth    = get(wmk,'depth');
hinge    = get(wmk,'hinge_bottom');
wmk_type = get(wmk,'type');
%
X_A  = Fwm(1:n_fft/2); % keeping only frequencies between 0 and f_acq / 2
freq = (wm(1:n_fft/2)-wm(1))/(2*pi);

k = wave_number(freq, depth);

TF(1) = 1;
for i1=2:length(k)
    TF(i1) = TF_wmk(wmk_type,k(i1) * depth, hinge/depth);
end
X_F = X_A .* TF;
X_F2 = [X_F 0 conj(fliplr(X_F(2:n_fft/2)))].'; % adding negative frequencies (real signal X(-w) = conj(X(w)))
X_test = ifft(X_F2) * length(X_F2)/2;
%
time2   = ((0:n_fft-1)*1/f_samp/n_fft)';
out_wmk = real(X_test);
%
out_FT_eta = (Fwm_init(1:n_fft/2));
out_FT_wmk = (X_F);
% %
% figure(4);
% plot(time2,real(X_test))%,time,real(X_filt))
% ylabel('Wave maker motion (m)')
% xlabel('Time (s)')
%
% figure(44);
% plot(freq,abs(Fwm_init(1:n_fft/2)),freq,abs(X_F),'r--')
% xlim([0 2])
% ylabel('TF Amplitude')
% xlabel('Frequency (Hz)')
% legend('Wave','Wave maker')

% test Free Surface elevation at wavemaker
X_F = X_A;
X_F2 = [X_F 0 conj(fliplr(X_F(2:n_fft/2)))].'; % adding negative frequencies (real signal X(-w) = conj(X(w)))
eta_test = ifft(X_F2) * length(X_F2)/2;

out_eta = real(eta_test);

% figure(5);
% plot(time,data)
% hold on
% plot(time2,real(eta_test),'r--')
% ylabel('Wave elevation (m)')
% xlabel('Time (s)')
