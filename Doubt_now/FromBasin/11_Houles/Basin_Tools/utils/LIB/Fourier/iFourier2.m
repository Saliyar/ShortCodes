function [signal, time] = iFourier2(FT)
% [signal, time] = iFourier2(FT)
% evaluates inverse Fourier transform with normalisation 2/N
% Input arguments
%  FT    structure containing 
%    FT.data   complex Fourier tranform (contains (FT.N+1/2) points)
%    FT.N      number of points
%    FT.freq   frequency vector in Hz
%    FT.f_samp sampling frequency
%    FT.T_d    signal duration
%
% Output
%  signal  data in column
%  time    time in s
%
% Constant (f=0) mode
FT.data(1,:) = 2 * FT.data(1,:);
% Last Fourier mode index
No2p1 = floor(FT.N / 2) + 1;
Np1o2 = floor((FT.N + 1) / 2);
%
% Adding negative frequencies
FT.data(No2p1+1:FT.N,:) = conj(flipud(FT.data(2:Np1o2,:)));
% Last mod if N is even
if mod(FT.N,2) == 0    
    FT.data(No2p1,:) = 2 * FT.data(No2p1,:);
end
% Inverse Fourier Transform
signal = real(ifft(FT.data) * FT.N / 2);
%
if nargout > 1 && isfield(FT, 'f_samp')
    % Time vector
    time = (0:FT.N-1) / FT.f_samp;
end