function [FT, time_out, freq] = moving_Fourier_resamp(signal, time_in, T_d, T_shift, f_samp)
% [FT, time_out, freq] = moving_Fourier_resamp(signal, time_in, T_d, T_shift, f_samp)
% Time frequency analysis using Short Time Fourier Transform (STFT)
%
% Inputs
%  signal  data in columns
%  time_in time vector in s
%  T_d     length of the moving window in s
%  T_shift distance between windows in s
%  f_samp  sampling frequency in Hz
%
% Outputs
%  FT   	moving complex Fourier tranform
%  time_out time in s
%  freq     frequency vector in Hz
%
% See also plot_moving.m, moving_Fourier.m
%
if nargin < 5
    error('Missing sampling frequency in moving_Fourier_resamp')
end
%
warning('off','FeBo:make_it_column')
signal = make_it_column(signal);
N_col  = size(signal,2);
% Total length
T = time_in(end) - time_in(1);
% Approximated number of data points per window 
n_TFD = floor(T_d * f_samp);
% Re-sampling frequency
f_resamp = n_TFD / T_d; % now n_pts is the exact number of points per window
% Number of moving TFD
n_moving = floor((T - T_d) / T_shift);
%
% Time vector
time_out = time_in(1) + (0:n_moving-1) * T_shift + T_d / 2;
%
h_waiting_bar = waitbar(0,'Please wait...');
array_resamp = zeros(n_TFD, N_col);
% First TFD
time_resamp = time_in(1) + (0:n_TFD-1)/f_resamp;
for i=1:N_col
    array_resamp(:,i) = interp1(time_in, signal(:,i), time_resamp);
end
[FT(1, :, :), freq] = Fourier(array_resamp(1:n_TFD,:), f_samp);
% Phase shift
for m=1:N_col
    FT(1,:,m) = FT(1,:,m) .* exp(-2*1i*pi*freq*time_resamp(1));
end
% Remaining TFDs
for n = 2:n_moving
    time_resamp = time_resamp + T_shift;
    for i=1:N_col
        array_resamp(:,i) = interp1(time_in, signal(:,i), time_resamp);
    end
    FT(n, :, :) = Fourier(array_resamp(1:n_TFD,:));
    waitbar(n / n_moving,h_waiting_bar)
    % Phase shift
    for m=1:N_col
        FT(n,:,m) = FT(n,:,m) .* exp(-2*1i*pi*freq*time_resamp(1));
    end
end
close(h_waiting_bar)

