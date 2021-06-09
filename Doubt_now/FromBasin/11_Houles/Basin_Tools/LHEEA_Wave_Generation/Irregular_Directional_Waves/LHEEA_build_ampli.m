function [harmo, ampli] = LHEEA_build_ampli(display, harmo, T_repeat, H_s, T_p, spectrum, gamma)
% [harmo, ampli] = LHEEA_build_ampli(display, harmo, T_repeat, H_s, T_p, spectrum, gamma)
% build amplitude spectrum from energy spectrum parameters
% Inputs
% display   #1  0 (no display) or 1 (display) for frequency components
% harmo     #2  harmonics number. Frequencies are harmo/T_repeat
% T_repeat  #3  repeat period used for base frequency estimation (cf. ocean/rnum)
% H_s       #4  significant wave height
% T_p       #5  peak period
% spectrum  #6  type of spectrum
% gamma     #7  gamma factor for Jonswap spectrum

% Should be better to define spectrum objects...
global spectra_names
% FontSize for Figures
fs = 13;

if any(strcmp(spectrum, spectra_names.jonswap))
    if nargin < 7
        error('FB_LHEEA','Missing gamma factor for Jonswap spectrum')
    end
end

%% Building the amplitude spectrum
% Frequency (Hz)
freq  = harmo ./ T_repeat;
% First moment (m^2)
m_0   = H_s^2/16;
% Peak ferquency (Hz)
f_p   = 1/T_p;
% erngy spectrum S(f)
switch spectrum
    case spectra_names.jonswap
        S = jonswap(freq, f_p, m_0, gamma);
    case spectra_names.bretsch
        S = bretsch_ocean(freq, f_p, m_0);
    otherwise
        error([spectrum, spectra_names.error])
end
m_0_eff = trapz(freq, S);
disp(['Missing energy for given harmonics = ', num2str((m_0-m_0_eff)/m_0*100,2), ' %'])
% amplitude spectrum from energy spectrum S(f)
ampli = sqrt(2*S/T_repeat);
%% display
if display
    figure(10), clf, subplot(1,2,1)
    plot(freq*T_p, S/max(S))
    subplot(1,2,2)
    plot(freq*T_p, ampli/max(ampli))
end
%% removing components whose amplitude is lower than 1% of the maximum (10% amplitude)
% % Cu = cumsum(S)/T_repeat;
% % ind_cum_start = find(Cu >= 0.01*m_0,1);
% % Cu = cumsum(fliplr(S))/T_repeat;
% % ind_cum_stop = length(S) - find(Cu >= 0.01*m_0,1);
% % ind = ind_cum_start:ind_cum_stop;
threshold = 1; % in%
S_threshold = threshold/100 * max(S);
ind   = find(S >= S_threshold);
if ind(1) > 1
    E_removed = trapz(freq(1:ind(1)), S(1:ind(1)));
else
    E_removed = 0;
end
if ind(end) < length(freq)
    E_removed = E_removed + trapz(freq(ind(end):end), S(ind(end):end));
end
harmo = harmo(ind);
ampli = ampli(ind);
disp('Restrictions')
disp(['f_min = ', num2str(freq(min(ind))), ' Hz'])
disp(['f_max = ', num2str(freq(max(ind))), ' Hz'])
disp(['Removed energy for ', num2str(threshold), '% threshold = ', num2str(E_removed/m_0*100,2), ' %'])
if display
    figure(10), subplot(1,2,2), hold all
    plot(freq(ind)*T_p, ampli/max(ampli))
    for sub=1:2, subplot(1,2,sub), set(gca, 'FontSize', fs), xlim([0,2*T_p]), add_vertical(1); add_vertical(freq([min(ind), max(ind)])*T_p); xlabel('Frequency fT_p'), end
    subplot(1,2,1), add_horizontal(S_threshold/max(S)); ylabel('S/max(S)')
    subplot(1,2,2), ylabel('a/max(a)'), legend('Original', 'Restricted 1%')
end
