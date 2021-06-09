function plot(s)
% PLOT ouvre une fenêtre et trace le graph du signal

temps = [0:s.dt:(length(s.Y)-1)*s.dt];

figure('Position',[100 400 1500 500]);

plot(temps,s.Y);hold on; grid on;
ylabel([s.nom ' (' s.unite ')'],'Interpreter','None');
xlabel('Time (sec)');
zoom on;



end