function [n_moving, FT_moving]  = Fourier_domain(elevation, n_inter, n_duration, n_mult, f_acq, n_plot, amplitude)
% -> [n_moving, FT_moving]  = Fourier_domain(elevation, n_inter, n_duration, n_mult, f_acq, n_plot, amplitude)
% INPUTS
% - elevation : signal d'élévation (time_components,nb_of_signals)
% - n_inter = n_inter
% - n_duration = Nb of points used at each calculation of the time step .
% n_duration= n_period*period* f_samp
% - n_mult : nb of periods for sliding fourier transform
% - f_acq=  re-sample frequency
% - amplitude and n_plot : plotting options

% OUTPUTS
% - n_moving = nb of time components of the fourier transform
% - FT_moving = Sliding Fourier transform(nb_of_time components,nb_of_frequency_components, nb_of_signals)

n_pts = size(elevation,1); % Nb of total points of the signal
n_moving   = floor((n_pts - n_duration) / n_inter); 
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
%     if n_plot >= 1
        time       = ((1:n_moving)-1) * n_inter / f_acq + n_duro2 / f_acq;
        n_freq_max = min(5 * n_mult, size(FT_moving,2));
        frequency  = (((1:n_freq_max)-1) * f_acq / n_duration)';
%         if nargin > 6
%             clim=[0 1.2*amplitude];
%         else
%             clim=[0 max(max(max(abs(FT_moving))))];
%         end
        %
%         figure(123);
%         imagesc(time,frequency,(abs(FT_moving(:,1:n_freq_max,1))'), [0. 0.4]*amplitude),
%         axis xy, colormap(flipud(gray))
%         X.dim     = 12;
%         X.label   = 't';
%         X.fonsize = 10;
%         X.offset  = -0;
%         Y.dim     = 8;
%         Y.label   = 'f';
%         Y.fonsize = 10;
%         Y.offset  = -0.;
%         %         make_figure(X,Y)
%         set(gca,'FontSize',10);

%         if n_plot == 1
%             %
%             freq_fig = figure(3);
%             set(freq_fig,'Name','Time-Frequency amplitude for each probes')
%             subplot(2,2,1)
%             %
%             if size(elevation,2) == 1
%                 tmp = squeeze(FT_moving(:,1,:));
%                 clear FT_moving
%                 FT_moving(:,:,1) = tmp;
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,1))',clim),
%                 axis xy, colormap(jet),
%             else
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,1))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 1
%                 subplot(2,2,2)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,2))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 2
%                 subplot(2,2,3)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,3))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 3
%                 subplot(2,2,4)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,4))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 4
%                 freq_fig = figure(5);
%                 set(freq_fig,'Name','Time-Frequency amplitude for each probes')
%                 subplot(2,2,1)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,5))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 5
%                 subplot(2,2,2)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,6))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 6
%                 subplot(2,2,3)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,7))',clim),
%                 axis xy, colormap(jet)
%                 colorbar
%             end
%             if size(elevation,2) > 7
%                 subplot(2,2,4)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,8))',clim),
%                 axis xy, colormap(jet)
%                 colorbar
%             end
%             if size(elevation,2) > 8
%                 freq_fig = figure(6);
%                 set(freq_fig,'Name','Time-Frequency amplitude for each probes')
%                 subplot(2,2,1)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,9))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 9
%                 subplot(2,2,2)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,10))',clim),
%                 axis xy, colormap(jet),
%             end
%             if size(elevation,2) > 10
%                 subplot(2,2,3)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,11))',clim),
%                 axis xy, colormap(jet)
%                 colorbar
%             end
%             if size(elevation,2) > 11
%                 subplot(2,2,4)
%                 imagesc(time,frequency,abs(FT_moving(:,1:n_freq_max,12))',clim),
%                 axis xy, colormap(jet)
%                 colorbar
%             end
%         end
%     end
end