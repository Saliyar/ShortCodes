function [n_moving, FT_moving]  = Fourier_domain(elevation, n_inter, n_duration, n_mult, f_acq, n_plot, amplitude)
%
n_pts = size(elevation,1);
n_moving   = floor((n_pts - n_duration) / n_inter);
%
%
moving    = [];
FT_moving = [];
calib     = 2.0 / n_duration;
n_duro2   = floor(n_duration/2);
n_start   = 0;
h_waiting_bar = waitbar(0,'Please wait...');
for n = 1:n_moving,
    tmp                = fft(elevation(n_start + (1:n_duration),:));
    FT_moving(n, :, :) = calib * tmp(1:n_duro2,:);
    FT_moving(n, 1, :) = FT_moving(n, 1, :) / 2;
    n_start            = n_start + n_inter;
    waitbar(n / n_moving,h_waiting_bar)
end
close(h_waiting_bar)
%
if nargin > 5
    if n_plot >= 1
        time       = ((1:n_moving)-1) * n_inter / f_acq + n_duro2 / f_acq;
        n_freq_max = min(5 * n_mult, size(FT_moving,2));
        frequency  = (((1:n_freq_max)-1) * f_acq / n_duration)';
    end
end