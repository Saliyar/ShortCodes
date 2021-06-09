close all
clear all
clc
% to be modified
% wave period
Period = 1.085;
a_0=0.0263;

signal = importdata('eta_phi_breather410');
%
Time = signal(:,1); % first column is time
eta  = signal(:,2); % second column is elevation
figure
plot(Time,eta,'b-+') 
hold on

frequency=1/Period;
n_period=1;
dt_samp=(Time(2)-Time(1));
f_samp=1/dt_samp;

%Resampl data for increasing number of points
dt_resamp = dt_samp /10;
f_resamp  = 1 / dt_resamp;
time_resamp      = Time(1):dt_resamp:Time(end);
eta_modified = interp1(Time, eta , time_resamp, 'spline');

figure(1);
plot(time_resamp,eta_modified,'r-+')
legend('eta' ,'eta_resamp')
%

%%
% harmonic analysis

[FT,freq,dt_FT,time2,n_t_FT] = moving_FFT_simplified(time_resamp,eta_modified,f_resamp,frequency, n_period);
time=1*Period;

figure(2);
n_time = floor(time / dt_FT);
stem(freq, squeeze(abs(FT(n_time,:))), 'g-')
% title(['Vitesse induite pour Amplitude RPM=',num2str(RPM_peak),'Tr/min']);
grid ('on')
xlim([0 5.1*frequency])
xlabel('Frequency [Hz]')
ylabel('Debit en X=0')

figure(3);
% plot fondamental
 plot(time2/Period, squeeze(abs(FT(:,n_period+1)))/a_0,'k', 'linewidth', 4)
% plot harmo 1
hold all
plot(time2/Period, squeeze(abs(FT(:,2*n_period+1)))/a_0, 'b', 'linewidth', 4)
plot(time2/Period, squeeze(abs(FT(:,3*n_period+1)))/a_0, 'r', 'linewidth', 4)
hleg1 = legend('1st harmonic','2nd harmonic','3rd harmonic')
set(gca, 'FontSize', 28);
xlabel ('t/T')
ylabel ('a(x)/a_0')


% plot phases
figure(4);
 plot(time2/Period, squeeze(angle(FT(:,n_period+1))),'k', 'linewidth', 4)
hold all
plot(time2/Period, squeeze(angle(FT(:,2*n_period+1))), 'b', 'linewidth', 4)
plot(time2/Period, squeeze(angle(FT(:,3*n_period+1))), 'r', 'linewidth', 4)
hleg1 = legend('phase 1st harmonic','phase 2nd harmonic','phase 3rd harmonic')
set(gca, 'FontSize', 28);
xlabel ('t/T')
ylabel ('angle')