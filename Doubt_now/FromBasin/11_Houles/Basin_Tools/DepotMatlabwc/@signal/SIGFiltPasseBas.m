function val = SIGFiltPasseBas(s,fc)
%function of class signal
%generate the Butterworth filter coefficients
%with the butter function and apply it with 
%the filtfilt function

fech = 1/s.dt;
fcnorm = fc/(fech/2);
[b,a] = butter(10,fcnorm,'low');

%affichage filtre
N = length(s.Y);
df=fech/N;
freq = 0:df:fech/2-df;
h=freqz(b,a,freq,100);
% % figure('Units', 'centimeters', 'Position', [17 1 15 20]);
% % subplot(211);
% % semilogy(freq,abs(h));
% % xlim([0 5]);
% % grid on;
% % zoom on;
%     
%---------------------filtrage!!-----------------
YFilt=filtfilt(b,a,s.Y);
YFilt=filtfilt(b,a,YFilt);


% % %affichage signaux brut et filtré
% % subplot(212);temps = [0:s.dt:(N-1)*s.dt];
% % plot(temps,s.Y);hold on; grid on;
% % plot(temps,YFilt,'r');
% % zoom on;

val = signal(YFilt,s.dt,s.nom,s.unite);
