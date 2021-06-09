function [FT, freq] = Fourier_analysis_TP_EI3_GBH(signal, time, f_houle, f_samp, t, N)
% Analyse en fr�quence de la houle
% P�riode de la houle
period = 1 / f_houle;
% Dur�e d'analyse
T_d = N * period;
% Nombre arrondi de points par fen�tre d'analyse
n_pts = floor(T_d * f_samp);
% Fr�quence de r�-�chantillonnage
f_resamp = n_pts / T_d;
% Resampled time vector
time_resamp = t:1/f_resamp:t+T_d;
% Data to be resampled
array_resamp = zeros(length(time_resamp),size(signal,2));
for i=1:size(signal,2)
    array_resamp(:,i) = interp1(time, signal(:,i), time_resamp);
end
% Frequency analysis
[FT, freq] = Fourier(array_resamp(:,:), f_resamp);
