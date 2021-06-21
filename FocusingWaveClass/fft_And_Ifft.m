function [Expt_yaxis]=fft_And_Ifft(TimeSeries,L,Fs)

%%%%Getting FFT 
Y = fft(TimeSeries);
f = Fs*(0:(L/2))/L;
%% Make it One sided FFT 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting one sided FFT with removed signal
% figure()
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Removing Unwanted Freq range in  function 
% Zero everything after 0.2 Hz 
maxFreq=50;
minFreq=0.2;
[~, idx1] = min(abs(f-maxFreq)); %Cut upto this Freq
[~, idx2] = min(abs(f-minFreq)); % Cut from this Freq
% which bin is closest to 10.1?
for i=idx2:idx1
Y(i)=0; 
Y (end-i +2)=0; % zero its complex conjugate
end

%% Make it One sided FFT 
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting one sided FFT with removed signal
%% Plot - Uncomment if required
% figure()
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)-Removed Extra Frequency')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

%% Inverse FFT of the time series obtained
Expt_yaxis=ifft(Y);
% plot(Expt_yaxis) 
% title('Time Series- Other Freq removed out')
% xlabel('Time (seconds)')
% ylabel('Amplitude')







