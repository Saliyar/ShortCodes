function plotallmotion(SPAR_Postprocessing_foamStar)

foamStarfullfile=fullfile(SPAR_Postprocessing_foamStar,'/motionInfo/0/cylinder.dat')
data=readtable(foamStarfullfile);
dt_motion=data{:,1};
motion_foamStar=data{:,2:end};

%% Plotting motions
for i=1:6
    dof6=motion_foamStar(:,i)

FigH = figure('Position', get(0, 'Screensize'));
    plot(dt_motion,dof6,'LineWidth',3)
    % xlim([0.05 20])
    ylabel('Motion','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['DOF ',num2str(i)],'FontSize',32)
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    grid on;
    
    saveas(FigH, ['DOF ',num2str(i)],'png');
end
