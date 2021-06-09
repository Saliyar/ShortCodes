function plotn(s)
% PLOT ouvre une fenêtre et trace le graph du signal
    
col = colormap(jet(length(s)));

figure;
leg = {};
for isig=1:length(s)   
    temps = [0:s(isig).dt:(length(s(isig).Y)-1)*s(isig).dt];
    h = subplot(1, 1, 1);
    plot(temps,s(isig).Y,'Color',col(isig,:));hold on; grid on; 
    ylabel(['Amplitude']);
    xlabel('Time (sec)');
    leg{isig} = [s(isig).nom ' (' s(isig).unite ')'];
    zoom on;
    set(h,'FontSize',16);
end
legend(leg);

end