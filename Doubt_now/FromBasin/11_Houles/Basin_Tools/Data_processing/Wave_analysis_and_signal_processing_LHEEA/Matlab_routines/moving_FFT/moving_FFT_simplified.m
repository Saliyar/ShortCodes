function  [FT,freq,dt_FT,time2,n_t_FT]= moving_FFT_simplified(time,signal,f_samp,frequency, n_period)
% -> [FT,freq,dt_FT,time2,n_t_FT]= moving_FFT_simplified(time,signal,f_samp,frequency, n_period)
% INPUTS:
% -time= vector of time
% -signal= signal (vector or Matrix) to be evaluated
% -f_samp = sample frequency (Hz)
% -frequency = frequency of the signal
% -n_period= number of periods for sliding fourier transform.
%
% OUTPUTS :
% - FT : Fourier transform of the signal (Complex) . FT(time component, frequency component)
% - freq : frequency vector associated with the Fourier Transform
% - dt_FT : time step for sliding fourier transform
% - time2 : time's vector with dt_FT for the time step
% - n_t_FT= number of components for time

period = 1 / frequency;
%
% number of points in the window
n_resamp  = floor(n_period * period * f_samp); % Nb of points used at each calculation of the time step
dt_resamp = (n_period * period) / n_resamp;
f_resamp  = 1 / dt_resamp;
%
time_resamp      = time(1):dt_resamp:time(end);
signal_for_fourier = transpose(interp1(time, signal  , time_resamp, 'spline'));
% 
n_inter = floor(0.5 * f_resamp);
%
amplitude = 0.14; % For plotting
disp('start fourier analysis')
%
[n_moving, FT] = Fourier_domain(signal_for_fourier, n_inter, n_resamp, n_period, f_resamp, 2, amplitude);
disp('Fourier finished')
%
freq   = (0:size(FT,2)-1) / size(FT,2) * f_resamp / 2;
dt_FT  = n_inter * dt_resamp;
time2  = (0:n_moving-1) * dt_FT + dt_FT / 2;
n_t_FT = n_moving;