function [f, y_abs] =  FFTMatrix(Sig,Fs)

L = length(Sig);
NFFT = L; %2^nextpow2(L); % Next power of 2 from length of y
Y = fft(Sig,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

 y_abs = 2*abs(Y(1:NFFT/2+1,:));
 
end