function [data]=analyse_data
%
% Choose the data file you want to process
[FileName,PathName] = uigetfile({'*.dat', 'HOS probe .dat files';...
    '*.*',  'All Files (*.*)'}, 'Input file');
% Read the data in the file
% and process the data (conversion from volts to physical values)
% Calibration matrix (dynamometer) and calibration values are given in
% read_data explicitly
% 
data = read_data([PathName '/' FileName]);
%
%
% Plot the different probes
figure(1)
%
for i=1:data.n_probes
    ax(i) = subplot(data.n_probes,1,i);
    plot(data.time, data.probes(:,i))
    ylabel('Wave elevation')
    xlabel('Time in s')
end
linkaxes(ax, 'x')
%
% Frequency analysis
f_houle = inputdlg('Wave frequency in Hz ');
f_houle = sscanf(f_houle{1}, '%f');
% Select the time window
[t x] = ginput(2);
% Choose an integer number of periods
N = floor(diff(t)*f_houle);
t(2) = t(1) + N/f_houle;
% plot the selected window
for n=1:data.n_probes
    subplot(data.n_probes,1,n)
%    add_vertical(t)
end
% Carry out the frequency analysis
[FT, freq] = Fourier_analysis_TP_GBH(data.probes, data.time, f_houle, data.f_samp, t(1), N);
%
% display the results
fprintf(1,'Amplitudes first harmonic:\n');
leg = [];
for i=1:data.n_probes
    leg = [leg 'Probe' num2str(i) ' %f m ; '];
end
leg = [leg '\n'];
fprintf(1,leg, abs(FT(N+1,1:data.n_probes)))
%
fprintf(1,'Amplitudes second harmonic:\n');
fprintf(1,leg, abs(FT(2*N+1,1:data.n_probes)))
%
fprintf(1,'Amplitudes third harmonic:\n');
fprintf(1,leg, abs(FT(3*N+1,1:data.n_probes)))
%
fprintf(1,'Amplitudes fourth harmonic:\n');
fprintf(1,leg, abs(FT(4*N+1,1:data.n_probes)))
%
% plot the results
figure(2)
for i=1:data.n_probes
    ax = plot_freq(i, freq, FT(:,i), data.n_probes);
    ylabel('Wave elevation')
    xlabel('Time in s')
end
xlim([0,4*freq(N+1)])

for n=1:data.n_probes
    subplot(data.n_probes,2,2*(n-1)+1)
    xlabel('Frequency in Hz')
    ylabel('Amplitude')
    subplot(data.n_probes,2,2*n)
    xlabel('Frequency in Hz')
    ylabel('Phase')
end    
%[ax,h3] = suplabel(['Wave frequency ' num2str(f_houle), 'Hz']  ,'t');
%set(h3,'FontSize',15)
FT(N+1,1)=0.01;
%
% plot harmonics as function of position
%
figure(3)
plot(data.position,abs(FT(N+1,:))/abs(FT(N+1,1)),'s') % first harmonic
hold all
plot(data.position,abs(FT(2*N+1,:))/abs(FT(N+1,1)),'o') % second harmonic
plot(data.position,abs(FT(3*N+1,:))/abs(FT(N+1,1)),'x') % third harmonic
plot(data.position,abs(FT(4*N+1,:))/abs(FT(N+1,1)),'d') % fourth harmonic
xlim([0,23])
legend('1st harmonic','2nd harmonic','3rd harmonic','4th harmonic')
%
% Order by order
%
figure(4)
subplot(4,1,1)
plot(data.position,abs(FT(N+1,:))/abs(FT(N+1,1)),'-s') % first harmonic
hold all
subplot(4,1,2)
plot(data.position,abs(FT(2*N+1,:))/abs(FT(N+1,1)),'-o') % second harmonic
hold all
subplot(4,1,3)
plot(data.position,abs(FT(3*N+1,:))/abs(FT(N+1,1)),'-x') % third harmonic
hold all
subplot(4,1,4)
plot(data.position,abs(FT(4*N+1,:))/abs(FT(N+1,1)),'-d') % fourth harmonic
hold all
%
for n=1:4
    subplot(4,1,n)
    xlabel('Position in m')
    ylabel(['a_' num2str(i) '/a_0'])
    legend('')
    xlim([0,23])
end

end
%
function data = read_data(file)
fid = fopen(file);
%
% acquisition
out = textread(file,'','headerlines',44);
%
data.n_probes = 1;
%data.n_probes = 10;
% % problem with number of columns...
% test=reshape(out',data.n_probes+1,[]);
% out = test';
% location of probes
data.position = [0.0];
%data.position = [2 4 5.2 12.5 13.5 14.5 15.7 17.3 19 21];
% data
data.time    = out(:,1);%/sqrt(9.81);
%fprintf('Warning, change to take into account problem of adim in HOS... to remove + reshape')
data.probes(:,1:data.n_probes) = out(:,2:data.n_probes+1);
%
data.f_samp = 1/(data.time(2)-data.time(1));
%
end
%
function ax = plot_freq(m, freq, data, n_probes)
ax(1) = subplot(n_probes,2,2*(m-1)+1);
hs = stem(freq, abs(data),'fill','-');
%
ax(2) = subplot(n_probes,2,2*m);
hp = plot(freq, angle(data),'o');
for n=1:length(hp)
    set(hp(n), 'MarkerFaceColor', get(hs(n), 'Color'));
end
%
end
