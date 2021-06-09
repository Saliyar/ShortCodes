%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Transform probe signal into
% ocean files for experiments
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function probe2ocean(filename_ocean,time,data,type_wmk)

if nargin < 4
    stop('not enough input arguments')
end
%
% Define wavemaker type
wmk = wavemaker(type_wmk);
%
clock_rate = 32;
%
% input data
time = time;
X    = data;
%
n_t   = length(time);
t_min = time(1);
t_max = time(n_t);
T_d   = t_max - t_min;
%
% Analysis
rnumb = nextpow2(clock_rate * T_d);
T_e   = pow2(rnumb) / clock_rate;
n_fft = pow2(nextpow2(n_t));
d_t   = T_e / n_fft;
n_d   = floor(T_d / d_t);
%
% 
X2 = interp1(time, X, ((0:n_d-1)*d_t));
%
% To check interpolation
figure;
plot(time,X,(0:n_d-1)*d_t,X2,'ro')
%
Fwm  = 2*fft(X2, n_fft) / n_fft;
% 0th component is not multiplied by 2
Fwm(:,1) = Fwm(:,1)/2;
wm       = 2*pi * (1:n_fft) / T_e;
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
ind   = find(ampli < 0.01 * max(ampli));
harmo(ind) = [];
ampli(ind) = [];
phase(ind) = [];
angl(ind)  = [];
%
harmo2 = harmonic(harmo, ampli, phase, angl);
% wave object
wv     = wave(T_e, f_samp, harmo2, wmk);%T_e is T_repeat
% % creating output file for HOS basin
%export(wv,'all',filename_ocean)
%
% ocean 2000 components rules
N_2000 = export(wv, 'ocean', filename_ocean);
%
%% output of ocean file
% Experiment title, will appear in wavemaker GUI
title = strcat('Time Reversal ... GIVE MORE DETAILS HERE?');
routine = mfilename; % for reference in the .wav files
%
fid = ocean_write_header(filename_ocean, title, routine);
ocean_write_data_read(fid, filename_ocean, 1, N_2000)
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
run = strcat('This is only one test for now'); %strcat('Tp', num2str(T_p), 's, Hs', num2str(H_s,3),'m');
ocean_write_run(fid, run, rnumb, 1)
fprintf(fid,'end;\n');
fclose(fid);
%
