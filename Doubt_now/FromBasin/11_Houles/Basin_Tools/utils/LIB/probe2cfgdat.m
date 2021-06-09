%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Transform probe signal into
% .cfg and .dat file for HOS-NWT simulation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function probe2cfgdat(filename_wmk,time,data,h,wmk_type,d)

if nargin < 5
    stop('not enough input arguments')
end
%
if wmk_type == 'hinged'
    if nargin < 6
        stop('not enough input arguments')
    end
elseif wmk_type == 'piston'
    d = [];
else
    stop('Unknown wmk type')
end
    
clock_rate = 32;
% h is the depth; %depth

time = time;
X    = data;
%
n_t = length(time);
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
X2 = interp1(time, X, ((0:n_d-1)*d_t));
%
% To check interpolation
% figure;
% plot(time,X,(0:n_d-1)*d_t,X2,'ro')
%
Fwm  = 2*fft(X2, n_fft) / n_fft;
% 0th component is not multiplied by 2
Fwm(:,1) = Fwm(:,1)/2;
wm    = 2*pi * (1:n_fft) / T_e;
%
f_samp = clock_rate / pow2(rnumb);
cfg = config(rnumb, clock_rate, h, [], [], [], 16, [], wmk_type,d);
%
n_cut = floor(Cutoff_max(cfg) * pow2(rnum(cfg)) / clock(cfg));
n_cut = min(n_cut, n_fft / 2);
%
%
%
harmo = [];
frequ = [];
ampli = [];
angl  = [];
phase = [];
% case m=0
m=0;
freq = m * f_samp;

harmo = [harmo m];
frequ = [frequ freq];
ampli = [ampli abs(Fwm(m+1))];
angl  = [angl  0.0];
phase = [phase angle(Fwm(m+1))];
for m = 1:n_cut
    freq = m * f_samp;
    harmo = [harmo m];
    frequ = [frequ freq];
    ampli = [ampli abs(Fwm(m+1))];
    angl  = [angl  0.0];
    phase = [phase angle(Fwm(m+1))];
end
%
harmo2 = harmonic(harmo, ampli, phase, angl);
wmk    = wavemaker(h, wmk_type, d);
wv     = wave(T_e, f_samp, harmo2, wmk);%T_e is T_repeat
% creating output file for HOS basin
% %export(wv,'all',fullfile(path, [filename,'_HOS']))
% export(wv,'all',[filename,'_HOS'])
export(wv,'all',filename_wmk)

%wv = wave(cfg, harmo, ampli, angl, phase);
%write(wv, [filename,'_HOS']);