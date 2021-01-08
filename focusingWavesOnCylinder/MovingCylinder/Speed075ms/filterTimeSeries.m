function [Expt_yaxis] = filterTimeSeries(yaxis)

%%Filtering the noises from Experimental results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Passing low pass filter over the Experimental results
Fs=9600;                                                                       % Sampling rate        
Fn=9600/2;                                                                      % Nyquist frequency
Wp =   5/Fn;                                                                    % Passband (Normalised)
Ws =  20/Fn;                                                                    % Stopband (Normalised)
Rp =  1;                                                                        % Passband Ripple
Rs = 25;                                                                        % Stopband Ripple
[n,Wn]  = buttord(Wp,Ws,Rp,Rs);                                                 % Filter Order
[b,a]   = butter(n,Wn);                                                         % Transfer Function Coefficients
[sos,g] = tf2sos(b,a);                                                          % Second-Order-Section For Stability
freqz(sos, 2048, Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Expt_yaxis= filtfilt(sos,g,yaxis);