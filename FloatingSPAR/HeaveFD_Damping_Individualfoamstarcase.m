function HeaveFD_Damping_Individualfoamstarcase(SPAR_Postprocessing_foamStar,nStart,nEnd,titlDecay,DOF)

%% Loading Numerical results 
for i=DOF
     
    
for j=nStart:nEnd
    
   SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)];
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar=data{:,1}; % This number is case specific to be updated
    pp1=data{:,2:end};
    pp2=pp1(:,3)-0.045;
        
    dt_motion_foamstar(end,1)
    N=1;
    [Tn,X,zeta]=logDecrement(dt_motion_foamstar,pp2,N);
end

    FigH = figure('Position', get(0, 'Screensize'));
    plot(X,zeta,'--,+','LineWidth',3)
    ylabel('\zeta[%]','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    xlim([0 100]);
    title (titlDecay{:,1},'interpreter','latex','FontSize',32);
    grid on;

end

