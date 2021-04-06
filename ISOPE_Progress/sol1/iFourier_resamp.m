function [signal, time] = iFourier_resamp(FT, N, f_samp, N2)
% [signal, time] = iFourier(FT, N, f_samp)
% evaluates inverse Fourier transform with normalisation 2/N
% Input arguments
%  FT     complex Fourier tranform (contains (N+1)/2 points)
%  N      number of points
%  f_samp sampling frequency
%  N2     number of resampled points
%
% Output
%  signal  data in column
%  time    time in s
%
%
% Félicien Bonnefoy, LHEEA/ECN, april 2016
%
% See also Fourier
%

% Constant (f=0) mode
FT(1,:) = 2 * FT(1,:);
%
% Adding negative frequencies
%   Last Fourier mode index
N_last = floor(N / 2) + 1;
FT(N_last+1:N,:) = conj(flipud(FT(2:floor((N + 1) / 2),:)));
%
% Inverse Fourier Transform
signal = real(ifft(FT,N2) * N / 2);
%
if nargout > 1 && nargin > 1
    % Time vector
    time = (0:N2-1) / f_samp * (N-1)/(N2-1);
elseif nargout > 1
    error('Missing sampling frequency in iFourier')
end