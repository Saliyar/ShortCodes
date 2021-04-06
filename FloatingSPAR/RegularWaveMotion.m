function RegularWaveMotion(Filelocation,ylbl)

    foamStarfullfile=fullfile(Filelocation,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion=data{:,1};
    pp=data{:,2:end};
    motion_foamStar=pp;



%% Plotting motions
FigH = figure('Position', get(0, 'Screensize'));
for i=5    
    dof6=motion_foamStar(:,i);  
    if (any(i>=4) && any(i<=6))
        dof6=dof6.*pi/180; 
        dof6=dof6-0.11;
    end 
    plot(dt_motion,dof6,'LineWidth',3)
    % ylim([-0.6 0])
    ylabel('Rotation[rad]','interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title ('Pitch','interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    % legend (lgd1{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
   
end
end

    

  