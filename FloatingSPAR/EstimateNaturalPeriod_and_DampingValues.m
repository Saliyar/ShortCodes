function EstimateNaturalPeriod_and_DampingValues(Exptpath,SPAR_Postprocessing_foamStar,titlDecay,nStart,nEnd,lgd6,phaseshift,DOF)

%% Loading Numerical results 
    dof=3;
    foamStarfullfile=fullfile(SPAR_Postprocessing_foamStar,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar=data{:,1}; % This number is case specific to be updated
    dof_foamstar=data{:,dof+1};

    phaseshift=6.14;
%% Loading Experimental Details 
   load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_Experiment=[pp_linear pp_rotation];
   
   for ii = 1:length(dt_motion)
         Ref_dt_Time(ii) = abs(dt_motion(ii) - phaseshift);
   end

   idx1=find((Ref_dt_Time)<0.005&(Ref_dt_Time)>0)

   for ii = 1:length(dt_motion)
         Ref_dt_Time(ii) = abs(dt_motion(ii) - round(dt_motion_foamstar(end)+phaseshift));
   end
   
   idx2=find((Ref_dt_Time)<0.0005&(Ref_dt_Time)>0)
   
   dof_expt=motion_Experiment(idx1:idx2,dof);
   dt_expt=dt_motion(idx1:idx2);
   dt_expt=dt_expt-dt_expt(1);
   dof_expt=dof_expt-dof_expt(1);
   


%% Interpolate to match the timestep
dof_foamstar1=interp1(dt_motion_foamstar,dof_foamstar,dt_expt,'cubic');

%% PLot the Time series
%    figure()
%     plot(dt_expt,dof_foamstar1,'LineWidth',3)
%     hold on
%     plot(dt_expt,dof_expt,'LineWidth',3)
%     xlim([0 phaseshift+25])
%     ylabel('Heave FD ','interpreter','latex','FontSize',32)
%     xlabel('Time [s]','interpreter','latex','FontSize',32)
%     set(gca,'Fontsize',32)
%     % title (titl{:,i},'interpreter','latex','FontSize',32);
%     % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
%     legend ('foamStar','Experiment','interpreter','latex','FontSize',32,'Location','southwest');
%     grid on;
%     pause();

%% 

    N=3; % Number of peaks to be compared for every one peak or every 2 peaks
    
    [Tn,X,zeta]=logDecrement(dt_expt,dof_foamstar1,N);
  

    Nat_period=Tn;
    
    figure()
    
    plot(X,zeta,'--','LineWidth',3) 
     hold on;
     
    [Tn,X,zeta]=logDecrement(dt_expt,dof_expt,N);

    Nat_period_expt=Tn;
    
    plot(X,zeta,'--','LineWidth',3) 
    ylabel('\zeta[%]','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    xlim([8.66 25]);
    title ('Damping Ratio','interpreter','latex','FontSize',32);
    legend ('foamStar','Experiment','interpreter','latex','FontSize',32,'Location','northeast');
    grid on;
    hold off
    % saveas(FigH, titlDecay{:,1},'png');
    
    
