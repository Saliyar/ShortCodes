function [up down] = wbw_analysis(time, data, t_start, x, depth)
% [up down] = wbw_analysis(time, data, t_start, x, depth)
% LIB/WAVE_ANALYSIS/wbw_analysis
% Wave by wave analysis by up- and down-crossing study
% Inputs:
%  time:    time vector
%  data:    data array (row is time and column the different probes)
%  t_start: optional, if one wants to remove the wave front
%  x:       optional, if the phase of the waves is to be evaluated (need depth)
%  depth:   optional, required if the phase is evaluated
%
% Outputs
%  up and down are data structures containing
%    H:      successive wave heights by up- or down-crossing analysis
%    T:      successive wave periods by up- or down-crossing analysis
%    time:   successive wave time by up- or down-crossing analysis
%    crest:  successive wave crest height
%    trough: successive wave trough height
%    phase:  successive wave phase (evaluated if 'x' and 'depth' are given)
%    N:      number of waves
%
% a smoothing might help to avoid spurious waves (when noise is near zero-crossing)
%     N_filt = 5;
%     data = filtfilt(ones(1,N_filt)/N_filt, 1, data); % moving average on N_filt points
%
% See also stat_wbw

data = make_it_column(data);
% removing early points during wave front
if nargin > 2
    f_samp  = 1 / (time(2) - time(1));
    if isempty(t_start)
        n_start = 1;
    else
        n_start = max(1,floor(t_start * f_samp));
    end
    time = time(n_start:end);
    data = data(n_start:end,:);
end
% # of probes
n_probe = max(min(size(data)),1);
%
% Finding the indices of the points before the zero
[i_zero_all, j_zero_all] = locate_crossing(data);
%
% let's go
for m = 1:n_probe
    % gather the zeros corresponding to the current probe
    i_zero = i_zero_all(j_zero_all == m);
    %
    data_slope = diff(data(:,m));
    % WARNING: data_slope has one element less than variable "data"
    %           BUT the last point can't have been chosen as a zero
    slope = sign(data_slope(i_zero));
    % separating up and down crossings
    i_up   = i_zero(slope > 0);
    i_down = i_zero(slope < 0);
    %     [maxi mini] = locate_max_min(data(:,m));
    %     i_up = maxi.i
    % numbers of up and down crossings
    n_up   = length(i_up);
    n_down = length(i_down);
    % Adjusting if not equal
    if n_up ~= n_down
        %         Not the same numbers of up- and down-crossings : trying ro remove
        %         the last one
        if n_up > n_down
            i_up(n_up) = [];
            n_up = n_up - 1;
        else
            i_down(n_down) = [];
            n_down = n_down - 1;
        end
    end
    missed = length(i_zero) - (n_up + n_down);
    if missed ~= 0
        %         warndlg(['We missed ' num2str(missed) ' zero-crossing(s)'])
        disp(['We missed ' num2str(missed) ' zero-crossing(s)'])
    end
    % find exact zero-crossing times by linear interpolation
    t_cross_up   = locate_t_crossing(time, data(:,m), i_up);
    t_cross_down = locate_t_crossing(time, data(:,m), i_down);
    % preparing results arrays
    a_max   = zeros(n_up,1);
    T_above = zeros(n_up,1);
    a_min   = zeros(n_up,1);
    T_below = zeros(n_up,1);
    % Periods and heights
    if i_up(1) < i_down(1) % on commence par un pic
        offset = 0;
        [a_max(n_up), ind_max(n_up)] = max(data(i_up(n_up):i_down(n_up+offset),m));
        T_above(n_up) = t_cross_down(n_up+offset) - t_cross_up(n_up);
    else % on commence par un creux
        offset = 1;
        [a_min(n_down), ind_min(n_down)] = max(data(i_down(n_down):i_up(n_down+1-offset),m));
        T_below(n_down) = t_cross_up(n_down+1-offset) - t_cross_down(n_down);
    end
    % les suivants
    for n = 1:n_up-1
        n
        max(data(i_up(n):i_down(n+offset),m))
        [a_max(n), ind_max(n)] = max(data(i_up(n):i_down(n+offset),m));
        T_above(n) = t_cross_down(n+offset) - t_cross_up(n);
        [a_min(n), ind_min(n)] = min(data(i_down(n):i_up(n+1-offset),m));
        T_below(n) = t_cross_up(n+1-offset) - t_cross_down(n);
    end
    % output data
    for n = 1:n_up-1
        up.time(n,m)     = time(i_down(n+offset));
        up.T(n,m)        = T_above(n) + T_below(n+offset);
        up.H(n,m)        = a_max(n)   - a_min(n+offset);
        up.crest(n,m)    = a_max(n);
        up.t_crest(n,m)  = time(i_up(n)+ind_max(n)-1);
        up.trough(n,m)   = a_min(n+offset);
        % up.t_trough(n,m) = time(i_down(n+offset)+ind_min(n)-1); % not tested yet
        down.time(n,m)   = time(i_up(n+1-offset));
        down.T(n,m)      = T_below(n) + T_above(n+1-offset);
        down.H(n,m)      = - a_min(n) + a_max(n+1-offset);
        down.crest(n,m)  = a_max(n+1-offset);
        % down.t_crest(n,m) = time(i_up(n+1-offset)+ind_max(n)-1); % not tested yet
        down.trough(n,m) = a_min(n);
        down.t_trough(n,m) = time(i_down(n)+ind_min(n)-1);
    end
    if nargin > 3
        % phase of the wave at distance 'x' in a water depth 'depth'
        for n = 1:n_up-1
            k = wave_number(1/up.T(n,m),depth);
            up.phase(n,m)   = mod( 2*pi * (up.time(n,m) - up.T(n,m) / 4) / up.T(n,m) - k*x(m), 2*pi);
            k = wave_number(1/down.T(n,m),depth);
            down.phase(n,m) = mod( 2*pi * (down.time(n,m) + down.T(n,m) / 4) / down.T(n,m) - k*x(m), 2*pi);
        end
    end
    % # of zero-crossings
    up.N(m) = n_up - 1;
    down.N(m) = n_down - 1;
end
%
% removing zeros
up   = remove_zeros(up, n_probe);
down = remove_zeros(down, n_probe);
%
function up_down = remove_zeros(up_down, n_probe)
N = max(up_down.N);
for m = 1:n_probe
    n = N;
    while up_down.time(n,m) == 0
        n = n-1;
    end
    up_down.time(n+1:N,m) = up_down.time(n,m);
end

