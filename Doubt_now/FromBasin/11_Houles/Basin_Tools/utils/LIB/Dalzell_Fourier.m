function [eta_1st, eta_2nd, a_2nd] = Dalzell_Fourier(a_1st, freq, time, h, f_samp)
% apply the Dalzell solution
% a_1st  amplitudes in m
% freq   frequency vector in Hz
% time   time vector in s
% h      water depth
% f_samp sampling frequency
%
% On enlève le mode constant le cas échéant
a_1st(freq == 0) = [];
freq(freq == 0)  = [];
% On suppose que la durée de répétition et la fréquence d'échantillonnage
% sont des puissances de 2
% ou simplement que le nombre de points est pair
N = length(freq); % even number of points in time, f_samp/2 = last mode not taken into account
if mod(N,2) == 0 % even
    a_1st(end) = [];
    freq(end)  = [];
end
% the freq is now index 2 to N-1, i.e. without constant mode nor last
% f_samp/2 mode
N = length(freq); % even number of points in time, f_samp/2 = last mode not taken into account
% gravity
g = 9.81;
% First order
fprintf(1,'First order\n')
k  = wave_number(freq.',h);
w  = 2*pi*freq.';
% Second order
fprintf(1,'Second order\n')
fprintf(1,'\tPreliminaries\n')
t = tanh(k.*h);
s = sinh(k.*h);
%   Self interaction or autoaction
fprintf(1,'\tSelf-interactions\n')
As =   k ./ (4.*t) .* (2 + 3./s.^2);
Ac = - k ./ (4.*t  .* (1 + s.^2));
%
fprintf(1,'\tPreliminaries\n') %#ok<*PRTCAL>
w1  = w * ones(1,N);
w2  = w1';
k1  = k * ones(1,N);
k2  = k1';
t1  = t * ones(1,N);
t2  = t1';
s1  = s * ones(1,N);
s2  = s1';
fprintf(1,'\tInteractions\n')
fprintf(1,'\t\tplus\n')
Dpm = (w1+w2).^2 - g.*(k1+k2).*tanh((k1+k2).*h);
Dpp = (w1+w2).^2 + g.*(k1+k2).*tanh((k1+k2).*h);
Ap  = w1.^2 + w2.^2 + (-w1.*w2.*(1-1./(t1.*t2)).*Dpp + ...
    (w1+w2) .* (w1.^3./s1.^2 + w2.^3./s2.^2)) ./ Dpm;
%   Minus term
fprintf(1,'\t\tminus\n')
Dmm = (w1-w2).^2 - g.*abs(k1-k2).*tanh(abs(k1-k2).*h) + diag(ones(size(freq)));
Dmp = (w1-w2).^2 + g.*abs(k1-k2).*tanh(abs(k1-k2).*h);
Am  = w1.^2 + w2.^2 + (w1.*w2.*(1+1./(t1.*t2)).*Dmp + ...
    (w1-w2) .* (w1.^3./s1.^2 - w2.^3./s2.^2)) ./ Dmm;
clear w2 k1 k2 t1 t2 s1 s2 k t s

fprintf(1,'First order\n')
fprintf(1,'Second order\n')
%   Self interaction or autoaction
a_1  = a_1st.' * ones(1,N);
a_2  = a_1.';
%
A_p = diag(a_1st.^2 .* As.') + triu(a_1 .* a_2 .* Ap  / (2*g), 1);
A_p = fliplr(A_p);
A_m = tril(a_1 .* conj(a_2) .* Am / (2*g), 1); 
% Sum modes
a_2nd = zeros(2*N,1);
for n=-(N-1):N-1
    a_2nd(N-n+1,1) = sum(diag(A_p, n));
end
% Difference modes
for n=1:N-1
    a_2nd(n,1) = a_2nd(n,1) + sum(diag(A_m, -n));
end
% Constant term
a_2nd = [sum(abs(a_1st).'.^2 .* Ac); a_2nd];
% last term
a_2nd = [a_2nd; 0];% even number of points in time, f_samp/2 = last mode
%
eta_2nd = iFourier(a_2nd, length(time), f_samp);
eta_1st = iFourier([0;a_1st.';zeros(size(a_1st.'));0], length(time), f_samp);
%
