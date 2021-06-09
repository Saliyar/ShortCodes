function wmkHOS_2_wav(iCase,scale)

%
% Transform a wavemaker file from HOS-NWT to corresponding wav file for use
% in ocean software (and perform experiments)
%

rmpath('C:\Program Files\MATLAB\R2018a\toolbox\symbolic\symbolic'); % Use in case of prob with harmonic



[filename,labelWave,refTime, refPosition, duration, scale, shift_phase, x_shift, window, foc_loc, filename_export]  = setupcase(iCase,scale);

%
f_min = 0.05; % min freq of wmk motion
f_max = 2; % max freq of wmk motion
%

%

%
cur_dir = pwd;
%
addpath(genpath('LIB'));

%
nheader  = 61;
%
[time, X, U] = extractdataFromWMKfile(filename, nheader);
dt   = time(2)-time(1);


figure;
plot(time,X)
%

%
% check duration is sufficient
depth  = 500;
Cg_min = group_velocity(f_max/sqrt(scale),wave_number(f_max/sqrt(scale),depth),depth);
if (duration/2<foc_loc/Cg_min)
    disp(['Time for f_max to reach refPosition : ' num2str(foc_loc/Cg_min) 's'])
    disp(['Current duration : ' num2str(duration/2) 's'])
    warning('duration not sufficient with respect to f_max') % Change from error
end
%
X    = X(time>window(1)&time<window(2));
time = time(time>window(1)&time<window(2));
%
hold on
plot(time,X,'r--')
%
starttime_orig =time(1);
time=time-starttime_orig;
display(['Starting time of the simu of ref (Orig Scale): ',  num2str(starttime_orig) ])
display(['Duration time of the simu of ref (Orig Scale): ',  num2str(time(end)) ])
%
% Apply ramps
%ramp_loc = 'both';
X  = ramp_time(time,X,1/dt,1*sqrt(scale),'both','cos'); % usually 1s at wave basin scale
%
figure;
plot(time,X)
%
%% Apply the correct scale factor
time = time/sqrt(scale);
X    = X/scale;
%
%% Create the files
wmk = wavemaker(500/scale,'hinged',300/scale); %define wavemaker used to produce wmk_motion.dat (taking into account the scale)
%
%time2wav(time, 0 , X, filename_out)
%
% Experiment title, will appear in wavemaker GUI
title = strcat('NonLinear Long Sea States - Extreme event');
routine = mfilename; % for reference in the .wav files
%
filename_export
fid     = ocean_write_header(filename_export, title, routine, 'nantes_main_posn\default.ttf');
fid_sum = ocean_write_summary_header(filename_export, title, routine, 'nantes_main_posn\default.ttf');
%
n_t   = length(time);
t_min = time(1);
t_max = time(n_t);
T_d   = t_max - t_min;
%
% Analysis
clock_rate = 32;
rnumb = nextpow2(clock_rate * T_d);%to ensure that Trepeat=256s
n_fft = pow2(nextpow2(n_t));
T_e   = pow2(rnumb) / clock_rate;
d_t   = T_e / n_fft;
n_d   = floor(T_d / d_t);
%
X2 = interp1(time, X, ((0:n_d-1)*d_t));
%
% To check interpolation
figure;
plot(time,X,(0:n_d-1)*d_t,X2,'ro')
%
Fwm(:,1) = 2*fft(X2, n_fft) / n_fft;
% 0th component is not multiplied by 2
Fwm(1) = Fwm(1)/2;
wm     = 2*pi * (1:n_fft) / T_e;
% store
Fwm_init = Fwm;
%
% Apply frequency cut-off
Fwm(wm/(2*pi)<f_min) = 0;
Fwm(wm/(2*pi)>f_max) = 0;
%
% To check fourier transform
figure;
subplot(1,2,1)
plot(wm/(2*pi),abs(Fwm))
subplot(1,2,2)
plot(wm/(2*pi),angle(Fwm))
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
freq  = m * f_samp;
%k     = wave_number(freq, get(wmk,'depth'));
TF    = 1; % what I have put in houle_lineaire
harmo = [harmo m];
frequ = [frequ freq];
ampli = [ampli abs(Fwm(m+1)/TF)];
angl  = [angl  0.0];
phase = [phase angle(Fwm(m+1)/TF)];
m0 = abs(Fwm(m+1)/TF)^2/(2);
for m = 1:n_cut
    freq = m * f_samp;
    k    = wave_number(freq, get(wmk,'depth'));
    kk(m) = k;
    TF = TF_wmk(get(wmk,'type'), k * get(wmk,'depth'), get(wmk,'hinge_bottom')/get(wmk,'depth'));
    freq_test(m) = freq;
    TF_test(m)=TF;
    harmo = [harmo m];
    frequ = [frequ freq];
    ampli = [ampli abs(Fwm(m+1)/TF)];
    angl  = [angl  0.0];
    phase = [phase angle(Fwm(m+1)/TF)];
    %
    m0=m0+abs(Fwm(m+1)/TF)^2/(2);
end
%
figure;
subplot(1,2,1)
plot(freq_test,abs(TF_test))
subplot(1,2,2)
plot(freq_test,angle(TF_test))

Hs=4*sqrt(m0);
disp(['Significant wave height of the wavemaker motion: Hs = ' num2str(Hs) 'm'])
%
% Remove too small amplitudes
ind   = find(ampli < 0.005 * max(ampli));
harmo(ind) = [];
ampli(ind) = [];
phase(ind) = [];
angl(ind)  = [];
frequ(ind) = [];
%
%% Define wavemaker we want to use!
wmk = wavemaker; %use of default wavemaker
%
harmo2 = harmonic(harmo, ampli, phase, angl);
% wave object
wv     = wave(T_e, f_samp, harmo2, wmk);%T_e is T_repeat
%
%% Apply a possible spatial shift

disp(['Position shift applied on wmk signal = ' num2str(x_shift) ' m'])
%
wv = position_shift(wv, -x_shift); %minus necessary for correction...
%
%% We have a problem with the phase...
wv = phase_shift(wv, shift_phase);
%
% output for ocean
[pathstr, name_short, ext] = fileparts(filename_export);
name_short = strcat(name_short, ext); %to prevent possible problems if name contains dots
%
% ocean 2000 components rules
ocean_write_summary_data(fid_sum, 1, wv);
N_2000 = export(wv, 'ocean', filename_export);
%
% To correct TF
%N_2000 = export(wv, 'ocean_correction_TF', filename_export);
%
%% output of ocean file
ocean_write_data_read(fid, name_short, 1, N_2000);
%
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
%for i1=1:length(amp)
    run = strcat('Extreme event localized in HOS-NWT simulation');
    ocean_write_run(fid, run, rnumb, 1);
%end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);
%
% creating output file for HOS-NWT
export(wv,'all',filename_export);
export(wv,'cfg', filename_export);