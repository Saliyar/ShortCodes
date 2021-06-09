function [FT, freq] = Fourier(signal, f_samp)
% [FT, freq] = Fourier(signal, f_samp)
% evaluates Fourier transform with normalisation 2/N
% Input arguments
%  signal  data in column
%  f_samp  sampling frequency in Hz (optional, required to evaluate freq)
%
% Outputs, expressed between f=0 and f=f_samp/2
%  FT    complex Fourier tranform (contains (N+1/2) points)
%  freq  frequency vector in Hz
%
signal = make_it_column(signal);
N      = length(signal);
FT     = 2 * fft(signal) / N;
% Constant (f=0) mode
FT(1,:) = FT(1,:) / 2;
%
% Removing negative frequencies
%   Last Fourier mode index
N_last = floor(N / 2) + 1;
FT(N_last+1:end,:) = [];
%
if nargin > 1 && nargout > 1
    T_d    = N / f_samp;
    % Frequency vector
    freq   = (0:N_last-1) / T_d;
elseif nargout > 1
    error('Missing sampling frequency in Fourier')
end
