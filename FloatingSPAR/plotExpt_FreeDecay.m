function plotExpt_FreeDecay(Exptpath,titl,ylbl,lgd2)

    load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_foamStar=[pp_linear pp_rotation];
   T_nat=4.85;
% 
% 
% 
% 
%% Plotting motions
for i=5
    %% if Heave - Determine the damping and natural period and report that!!! 

    
    
  %  FigH = figure('Position', get(0, 'Screensize'));

    dof6=motion_foamStar(:,i); 
    
%         if i==3
%             dof6=dof6+1.535;
%             n=1; % Number of peaks     
%         [Tn,X,zeta]=logDecrement(dt_motion(1200:end),dof6(1200:end),n);
%         end
 %% Plotting the Decay 
%      FigH = figure('Position', get(0, 'Screensize'));
%     plot(X,zeta,'LineWidth',3)
%     ylabel('\zeta[%]','FontSize',32)
%     xlabel('Time [s]','interpreter','latex','FontSize',32)
%     set(gca,'Fontsize',32)
%     xlim([0 100]);
%     title ('Damping Ratio','interpreter','latex','FontSize',32);
%     grid on;
    
%% Plotting the Experimental time series    
    
     FigH = figure('Position', get(0, 'Screensize'));
    plot(dt_motion,dof6,'LineWidth',3)
    % xlim([0.05 2])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    %legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
   % legend (lgd2{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold on

    
end
% saveas(FigH, [titl{:,i}],'png');
% FigH = figure('Position', get(0, 'Screensize'));
%  subplot(2,1,1)
%  plot(dt_motion,motion_foamStar(:,i)-mean(motion_foamStar(6000:end,i)),'LineWidth',3) %2000 means from 10s, 6000 means 30s
%  ylabel('Surge motion (m)','interpreter','latex','FontSize',32)
%  xlabel('Time [s]','interpreter','latex','FontSize',32)
%  % title ('Free decay','interpreter','latex','FontSize',32);
%  grid on;
% % grid minor;
%  set(gca,'Fontsize',32)
%  
%  subplot(2,1,2)
%  plot(dt_motion,motion_foamStar(:,5),'LineWidth',3)
%  ylabel('Degree','interpreter','latex','FontSize',32)
%  xlabel('Time [s]','FontSize',32)
%  title ('Experiment - Pitch Free decay','interpreter','latex','FontSize',32);
% pp_linear=[motion_foamStar(:,1)-motion_foamStar(1,1) motion_foamStar(:,2)-motion_foamStar(1,2) motion_foamStar(:,3)-motion_foamStar(1,3)];
% pp_rotation=[motion_foamStar(:,4)-motion_foamStar(1,4) motion_foamStar(:,5)-motion_foamStar(1,5) motion_foamStar(:,6)-motion_foamStar(1,6)];
% % pp_linear={A};
% FigH = figure('Position', get(0, 'Screensize'));
% newYlabels = {'Surge(m)','Sway(m)','Heave(m)'};
% s=stackedplot(dt_motion/T_nat, pp_linear,'DisplayLabels' , newYlabels);
% s.LineWidth = 2;
% s.XLabel={'Time [s]'};
% s.FontSize = 25; 
% s.FontName='Arial';
% s.Title='Heave -Experiment Free decay';
% grid on;
%  
% 
% FigH = figure('Position', get(0, 'Screensize'));
% newYlabels = {'Roll(rad)','Pitch(rad)','Yaw(rad)'};
% s=stackedplot(dt_motion/T_nat, pp_rotation,'DisplayLabels' , newYlabels);
% s.LineWidth = 2;
% s.XLabel={'Time [s]'};
% s.FontSize = 25; 
% s.FontName='Arial';
% s.Title='Heave -Experiment Free decay';
% grid on;
end

