%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code to check the Infleunce of Outer Box in SPAR foamStar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  SPAR_FreeSurfaceWidth_HeaveFD(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
 
%% Loading Experimental Details 
load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   % Removing Ramp time 
   dt_motion=dt_motion(2000:end,:); % 2000 for 6s
 %  length(dt_motion)
%   motion_Experiment=[pp_linear(1260:end,:) pp_rotation(1260:end,:)];
 
   motion_Experiment(:,3)= pp_linear(2000:end,3)- mean(pp_linear(2000:end,3));% 2000 for 6s
 
   % Finding the first peak
   
   [pks_expt,locs_expt] = findpeaks(motion_Experiment(:,3),'MinPeakHeight',0.01,'MinPeakDistance',1000);
   % findpeaks(motion_Experiment(:,3),'MinPeakHeight',0.01,'MinPeakDistance',1000)
  
   Start_index=locs_expt(1)+3
    
   
   dt_motion=dt_motion(Start_index:end,:);
   dt_motion=dt_motion-dt_motion(1);
 
   Heave_Experiment=motion_Experiment(Start_index:end,3);
 
%% Loading Numerical results 
n=0;
diff_timestep=0;
Endlimit=23100;
for j=nStart:nEnd
   n=n+1;
    SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)]
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat')
    data=readtable(foamStarfullfile); 
    endtime=data{end,1}
   % findpeaks(data{:,4})
    [pks,locs] = findpeaks(data{:,4},'MinPeakHeight',0.01,'MinPeakDistance',200);
    
    if (n>1)
        
            diff_timestep=locs(1)-len;
           if(n==3)
              %  diff_timestep=diff_timestep-2;
           end
           if(n==4)
               diff_timestep=diff_timestep+68;
           end
    end
    foamstar_time=data{locs(1):Endlimit+diff_timestep,1};
    foamstar_time=foamstar_time-foamstar_time(1);
    dt_motion_foamstar{:,n}= foamstar_time;% This number is case specific to be updated
    length(locs(1):Endlimit+diff_timestep)
    
    pp=data{locs(1):Endlimit+diff_timestep,2:end};
    pp3=pp(:,3); % For Heave Free decay -1.535 moved 0.045  
    
    % Find the Difference in the peak
    diff=motion_Experiment(locs_expt(1)+3,3)-pks(1);
    pp3=pp3+diff;
    pp4=[pp(:,1) pp(:,2) pp3 pp(:,4) pp(:,5) pp(:,6)];
    len=locs(1);
    j
    length(pp4)
    motion_foamStar(:,:,n)=pp4;
    % Adding for surge, Sway, Heave
    
end
% 
% 
% 
% 
%% Plotting motions
for i=3
    
     clear n
     n=0;
      FigH = figure('Position', get(0, 'Screensize'));
for j=nStart:nEnd   
 
    n=n+1;
    dof6=motion_foamStar(:,i,n); 
    plot(dt_motion_foamstar{:,n},dof6,'LineWidth',3)
    hold on;
end
    
  
   plot(dt_motion,Heave_Experiment,'Linestyle','--','LineWidth',3,'color','k')
    xlim([0 21])
    ylim([-0.06 0.06])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    % legend ('Free Surface Box Width 0.5D ','Free Surface Box Width 0.25D','Experiment','interpreter','latex','FontSize',32);
    legend ('foamStar PPSD35SL4','Experiment','interpreter','latex','FontSize',32);
    %legend (lgd3{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    grid minor;
    hold off
    
 
saveas(FigH, [titl{:,i}],'png');
end
