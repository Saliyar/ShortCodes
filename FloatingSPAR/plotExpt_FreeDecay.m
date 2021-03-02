function plotExpt_FreeDecay(Exptpath,titl,ylbl,lgd2)

    load(Exptpath)
   dt_motion=data4CFD.time;
   pp_linear=data4CFD.CoG_motion;
   pp_rotation=data4CFD.CoG_rotation;
   motion_foamStar=[pp_linear pp_rotation];
% 
% 
% 
% 
%% Plotting motions
for i=1:6
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
    % xlim([0.05 20])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title (titl{:,i},'interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
   % legend (lgd2{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold on

    
end
saveas(FigH, [titl{:,i}],'png');
end
