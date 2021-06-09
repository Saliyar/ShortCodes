function val = SIGSpeedAcc(s)
%function of class signal
%calculates the speed and acceleration of a signal
%and returns the corresponding two signal objects
%in an array = [signalSpeed signalAcc]
%
%syntax : 
%val = SIGSpeedAcc(signal)

temps = [0:s.dt:(length(s.Y)-1)*s.dt];
vit = diff(s.Y)/s.dt;
sigvit = signal(diff(s.Y)/s.dt,s.dt,s.nom,[s.unite '/s']);
sigvit2 = SIGFiltPasseBas(sigvit,2);
acc = diff(sigvit2.Y)/s.dt;

figure;
subplot(3,1,1);
plot(temps,s.Y);hold on; grid on;
ylabel([s.nom ' (' s.unite ')']);
xlabel('Time (sec)');
zoom on;

subplot(3,1,2);
plot(temps(1:end-1),sigvit.Y);hold on; grid on;
plot(temps(1:end-1),sigvit2.Y , 'r');
ylabel([s.nom ' (' s.unite '/s)']);
xlabel('Time (sec)');
zoom on;

subplot(3,1,3);
plot(temps(1:end-2),acc);hold on; grid on;
ylabel([s.nom ' (' s.unite '/s2)']);
xlabel('Time (sec)');
zoom on;

whos

val = [ temps(1:end-2) ; sigvit.Y(1:end-1)' ; acc' ];
