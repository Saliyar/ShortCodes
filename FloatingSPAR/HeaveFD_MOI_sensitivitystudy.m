function  HeaveFD_MOI_sensitivitystudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd5,phaseshift)

%% Loading Experimental Details 
   load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_Experiment=[pp_linear pp_rotation];
 
%% Loading Numerical results 
n=0;

for j=nStart:nEnd
   n=n+1;
    SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)];
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion_foamstar{:,n}=data{1:5000,1}+phaseshift; % This number is case specific to be updated
    pp=data{1:5000,2:end};
    pp1=pp(:,1)+16.95;
    pp2=pp(:,2)+14.84;
    pp3=pp(:,3)-1.584; % For Heave Free decay -1.535 moved 0.045  
    
     Y=fft(pp3);
     L=length(dt_motion_foamstar{:,n});
     P2 = abs(Y/L);
%      P1 = P2(1:L/2+1);
%      P1(2:end-1) = 2*P1(2:end-1);
%      Fs=100;
%      f = Fs*(0:(L/2))/L;
%      figure()
%      plot(P2) 
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
    
    pp4=[pp1 pp2 pp3 pp(:,4) pp(:,5) pp(:,6)];
    
    motion_foamStar(:,:,n)=pp4;
    % Adding for surge, Sway, Heave
    
end
% 
% 
% 
% 
%% Plotting motions
for i=1:6
    
     clear n
     n=0;
      FigH = figure('Position', get(0, 'Screensize'));
for j=nStart:nEnd   
    
    n=n+1;
    dof6=motion_foamStar(:,i,n); 
    plot(dt_motion_foamstar{:,n},dof6,'LineWidth',3)
    hold on;
end
    
    dof6=motion_Experiment(:,i); 

    plot(dt_motion,dof6,'LineWidth',3)
    xlim([0 75])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    legend (lgd5{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold off
    

saveas(FigH, [titl{:,i}],'png');
end
