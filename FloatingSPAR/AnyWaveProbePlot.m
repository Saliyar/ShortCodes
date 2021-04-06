function AnyWaveProbePlot(foamstar2DRegularwavePath)  
%% Loading foamstar wave
foamStarfullfile=fullfile(foamstar2DRegularwavePath,'/postProcessing/waveProbe/0/surfaceElevation1.dat')
data=load(foamStarfullfile);
dt_foamStar=data(:,1);
Eta_foamStar=data(:,2:end);
[m,n]=size(Eta_foamStar)
probelocation=100;
Y_axis=Eta_foamStar(:,probelocation);

%% Getting the input from CN Stream
% numberofPeaks=20;
%[dt_stream,Eta_stream]= CallingCNStreamOutput(numberofPeaks);

%% Plot foamstar wave
FigH = figure('Position', get(0, 'Screensize'));

plot(dt_foamStar,Y_axis,'LineWidth',3);
% hold on 
% plot(dt_stream,Eta_stream,'LineWidth',3);

ylabel('Elevation(m)','FontSize',32,'interpreter','latex')
xlabel('Time [s]','FontSize',32,'interpreter','latex')
% xlim([0.5 15])
set(gca,'Fontsize',32)
title('Incident wave' ,'FontSize',32,'interpreter','latex')
% legend ('foamStar','Experiment','FontSize',32,'interpreter','latex');
grid on;
hold off;





