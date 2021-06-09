function [FT, time, freq] = moving_Fourier(signal, n_TFD, n_shift, f_samp, det)
% [FT, time, freq] = moving_Fourier(signal, n_TFD, n_shift, f_samp)
% Inputs
%  signal  data in column
%  n_TFD   number of points for the TFD
%  n_shift number of points for the time shift between each TFD
%  f_samp  sampling frequency in Hz (optional, required to evaluate freq)
%  det     detrend type among 'linear', 'mean'...
%
% Outputs
%  FT    moving complex Fourier tranform
%  time    time in s
%  freq  frequency vector in Hz
%
% See also plot_moving.m
%
if nargout > 1 && nargin < 4
    error('Missing sampling frequency in moving_Fourier')
end
%
signal = make_it_column(signal);
% Total number of points
N        = size(signal,1);
% Number of moving TFD
n_moving = floor((N - n_TFD) / n_shift);
%
% Time vector
time = ((0:n_moving-1) * n_shift + n_TFD / 2) / f_samp;
%
h_waiting_bar = waitbar(0,'Please wait...');
% First TFD
if nargin > 3
    if nargin < 5
        [FT(1, :, :), freq] = Fourier(signal(1:n_TFD,:), f_samp);
    else
        [FT(1, :, :), freq] = Fourier(detrend(signal(1:n_TFD,:), det), f_samp);
    end
    % Phase shift
    for m=1:size(signal,2)
        FT(1,:,m) = FT(1,:,m) .* exp(-2*1i*pi*freq*time(1));
    end
else
    if nargin < 5
    FT(1, :, :) = Fourier(signal(1:n_TFD,:));
    else
    FT(1, :, :) = Fourier(detrend(signal(1:n_TFD,:), det));
    end
end
% Advancing to next time shift
n_start = n_shift;
% Remaining TFDs
for n = 2:n_moving
    if nargin < 5
        FT(n, :, :) = Fourier(signal(n_start + (1:n_TFD),:));
    else
        FT(n, :, :) = Fourier(detrend(signal(n_start + (1:n_TFD),:), det));
    end
    % Advancing to next time shift
    n_start = n_start + n_shift;
    waitbar(n / n_moving,h_waiting_bar)
    if nargin > 3
        % Phase shift
        for m=1:size(signal,2)
            FT(n,:,m) = FT(n,:,m) .* exp(-2*1i*pi*freq*time(n));
        end
    end
end
close(h_waiting_bar)
%
