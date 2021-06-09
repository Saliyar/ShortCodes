function y = filt_high_pass(eta, f_s ,f_c)
% y = filt_low_pass(eta, f_s ,f_c)
% Low pass filter (perfect)
% eta   :   signal that needs filtering
% f_s   :   sampling frequency
% f_c   :   cutoff frequency

% Number of points
N   = size(eta,1);
% Fourier transform
FT  = fft(eta);
% cutoff number
n_c = floor(N / f_s * f_c);
% just so to remember : f_c = 2 * n_c * f_s / N;
% Filtering
FT(1:n_c+1,:) = 0;
% back to time domain
y   = real(ifft(FT));
