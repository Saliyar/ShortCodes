function  CompareRegularWaveExptmotion(Expt_regular_path,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd2,phaseshift)

%% Loading Experimental Details 
   load(Expt_regular_path)
   dt_motion=data.time;
   pp_linear=data.CoG_motion;
   pp_rotation=data.CoG_rotation;
   pp_tension=data.tension;
   
   
   %% Modifying the Experiment resutls for starting point matching with CFD
   
   motion_Experiment=[pp_linear pp_rotation];
 
%% Loading Numerical results 
    foamStarfullfile=fullfile(SPAR_Postprocessing_foamStar,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar=data{:,1}; 
    motion_foamStar=data{:,2:end};
%% Plotting motions
for i=1:6
    
   dof6=motion_foamStar(:,i); 
    if (any(i>=4) && any(i<=6))
        dof6=dof6.*pi/180;   
    end
    
    FigH = figure('Position', get(0, 'Screensize'));
    
    plot(dt_motion_foamstar,dof6,'LineWidth',3)   
    dof6=motion_Experiment(:,i);
    dof6=dof6-dof6(1);
    hold on;
    plot(dt_motion,dof6,'LineWidth',3)
    
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    legend (lgd2{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold on
end
end
