function  Heave_FD_TurbulentModelstudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd7,phaseshift)

%% Loading Experimental Details 
   load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_Experiment=[pp_linear pp_rotation];
 
%% Loading Numerical results 
for i=1:6
    clear n
     n=0;
     FigH = figure('Position', get(0, 'Screensize'));
    
for j=nStart:nEnd
   n=n+1;
    
   SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)];
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar=data{:,1}+phaseshift; % This number is case specific to be updated
    pp=data{:,i+1};
    
    if (i==1)
        pp=pp+16.95;
    elseif (i==2)
        pp=pp+14.84;
    elseif i==3
        pp=pp-1.584; % For Heave Free decay -1.535 moved 0.045  
    end
    
    plot(dt_motion_foamstar,pp,'LineWidth',3)
    hold on;
end
    dof6=motion_Experiment(:,i);
    plot(dt_motion,dof6,'LineWidth',3)
    
    xlim([0.05 40])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    legend (lgd7{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold off
    saveas(FigH, [titl{:,i}],'png');
end
