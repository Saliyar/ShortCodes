function plot_moving_mag(FT, time, freq, f_max, plot_type, amplitude, probe)
% plot_moving_mag(FT, time, freq, f_max, plot_type, amplitude, probe)
%
% f_max     (optional) maximum frequency in plot (default is max(freq))
% plot_type (optional) 1=first probe in reverse grayscale colormap
%                      2=all probes in groups of four, jet colormap
%                      (default is 1)
% amplitude (optional) reference amplitude for the contour line (default is
%           max(FT). Useful to make the nonlinear structure appear if you
%           set amplitude to max(FT)/5 or /10.
%
% See also moving_Fourier, plot_moving.m
%
if nargin < 4
    f_max = max(freq);
end
if nargin < 5
    plot_type = 1;
end
if nargin < 6
    amplitude = squeeze(max(max(abs(FT(:,:,:)))));
end
% signal to be plotted
if nargin < 7
    probe = 1;
end
%
Delta_f = diff(freq(1:2));
n_freq_max = min(floor(f_max / Delta_f), size(FT,2));
if plot_type == 1
    figure(123),clf
%     ax(1) = subplot(1,2,1);
    imagesc(time,freq(1:n_freq_max),(abs(FT(:,1:n_freq_max,probe))'), [0. 0.4]*amplitude(probe))
    colormap(flipud(gray))
%     ax(2) = subplot(1,2,2);
%     imagesc(time,freq(1:n_freq_max),(angle(FT(:,1:n_freq_max,probe))'))
%     colormap(flipud(gray))
%     linkaxes(ax,'xy')
    axis xy
elseif plot_type == 2
    clim=[zeros(size(amplitude)), 1.2*amplitude];
    %
    freq_fig = figure(123);
    set(freq_fig,'Name','Time-Frequency amplitude for each probes')
    for n=1:4
        if size(FT,3) > n-1
            subplot(2,2,n)
            %
            imagesc(time,freq(1:n_freq_max),abs(FT(:,1:n_freq_max,n))',clim(n,:)),
            axis xy, colormap(jet),
        end
    end
    if size(FT,3) > 4
        freq_fig = figure(124);
        set(freq_fig,'Name','Time-Frequency amplitude for each probes')
        for n=1:4
            if size(FT,3) > 3+n
                subplot(2,2,n)
                imagesc(time,freq(1:n_freq_max),abs(FT(:,1:n_freq_max,4+n))',clim(4+n,:)),
                axis xy, colormap(jet),
            end
        end
    end
    if size(FT,3) > 8
        freq_fig = figure(125);
        set(freq_fig,'Name','Time-Frequency amplitude for each probes')
        for n=1:4
            if size(FT,3) > 7+n
                subplot(2,2,n)
                imagesc(time,freq(1:n_freq_max),abs(FT(:,1:n_freq_max,8+n))',clim(8+n,:)),
                axis xy, colormap(jet),
            end
        end
    end
end
