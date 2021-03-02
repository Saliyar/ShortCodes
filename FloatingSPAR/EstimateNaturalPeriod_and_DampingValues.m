function EstimateNaturalPeriod_and_DampingValues(Exptpath,SPAR_Postprocessing_foamStar,titlDecay,nStart,nEnd,lgd6,phaseshift,DOF)

%% Loading Experimental Details 
   load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_Experiment=[pp_linear pp_rotation];
 
%% Loading Numerical results 
for i=DOF
    clear n
     n=0;
     FigH = figure('Position', get(0, 'Screensize'));
    
for j=nStart:nEnd
   n=n+1;
    
   SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)];
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar=data{:,1}; % This number is case specific to be updated
    pp=data{:,i+1}-0.045;
    
   
    N=1; % Number of peaks to be compared 
    
    [Tn,X,zeta]=logDecrement(dt_motion_foamstar,pp,N);
    hold on;

    Nat_period(j)=Tn;
    
    plot(X,zeta,'--','LineWidth',3) 
     hold on;
end
    dof6=motion_Experiment(:,i);
    
    if i==3
            dof6=dof6+1.535;
            N=1; % Number of peaks     
        [Tn,X,zeta]=logDecrement(dt_motion(1200:end),dof6(1200:end),N);
    end
    Nat_period_expt=Tn;
    
    plot(X,zeta,'--','LineWidth',3)
    ylabel('\zeta[%]','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    xlim([0 100]);
    title ('Damping Ratio','interpreter','latex','FontSize',32);
    legend (lgd6{:},'interpreter','latex','FontSize',32,'Location','northeast');
    grid on;
    hold off
    saveas(FigH, titlDecay{:,1},'png');
    
    %% Plot Natural period for different case 
    for k=1:nEnd+1
        Tn_expt(k)=Nat_period_expt;
    end
    
    FigH = figure('Position', get(0, 'Screensize'));
    fontsize=32;
     hhh=2;
    markerSet='osp^>v<d*';
    % colorOrder = get(gca,'ColorOrder');
    cOrder = colormap(cbrewer('qual', 'Dark2', 8));
    markersize = 32;
    linewidth = 4;
    rect = [3 5 30 18];
    rect2 = [3 5 30 18];
    rect3 = [3 5 20 16];
   
    for i=nStart:nEnd    
    scatter(i,Nat_period(i),'d','LineWidth',25)
    hold on
    end
    plot(Tn_expt,'--','LineWidth',3)
    hold on
    ylabel('Natural period(s)','FontSize',32)
    xlabel('Test cases','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    ylim([Nat_period_expt-0.25 Nat_period_expt+0.25]);
    set(gca,'XLim',[nStart nEnd+1])
    set(gca,'XTick',(nStart:1:nEnd+1))
    title ('Natural period','interpreter','latex','FontSize',32);
    legend (lgd6{:},'interpreter','latex','FontSize',32,'Location','northeast');
    grid on;
    
    hold off
    saveas(FigH, titlDecay{:,2},'png');
    
    
end

