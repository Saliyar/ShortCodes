function FT = Fourier2(signal, f_samp)
% FT = Fourier2(signal, f_samp)
% evaluates Fourier transform with normalisation 2/N
% Input arguments
%  signal  data in column
%  f_samp  sampling frequency in Hz (optional)
%
% Outputs, expressed between f=0 and f=f_samp/2
%  FT    structure containing 
%    FT.data   complex Fourier tranform (contains (FT.N+1/2) points)
%    FT.N      number of points
%    FT.freq   frequency vector in Hz
%    FT.f_samp sampling frequency
%    FT.T_d    signal duration
%
signal     = make_it_column(signal);
FT.N       = length(signal);
FT.data    = 2 * fft(signal) / FT.N;
% Constant (f=0) mode
FT.data(1,:) = FT.data(1,:) / 2;
% Last Fourier mode index
No2p1 = floor(FT.N / 2) + 1;
%
% Removing negative frequencies
FT.data(No2p1+1:end,:) = [];
%
% Last mod if N is even
if mod(FT.N,2) == 0    
    FT.data(No2p1,:) = FT.data(No2p1,:) / 2;
end
%
if nargin > 1
    FT.f_samp = f_samp;
    FT.T_d    = FT.N / FT.f_samp;
    % Frequency vector
    FT.freq   = (0:No2p1-1) / FT.T_d;
end
