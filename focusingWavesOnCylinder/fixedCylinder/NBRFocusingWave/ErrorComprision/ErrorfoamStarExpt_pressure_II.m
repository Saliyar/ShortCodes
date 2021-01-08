function ErrorfoamStarExpt_pressure_II(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost)

%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)

PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

%Selection time 5s to 35s overall. with constant phase shift is reduced

pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=pp2(ExptPressureIndices,1);
pl_timeB=pl_timeA-pl_timeA(1)-cps; %
Q4=0;

%% foamStar and foamStar SWENSE comparision

foamStarfullfile=fullfile(foamStarfile,'/probes/0/p')
data=readtable(foamStarfullfile);
dt_PP=data{:,1};
PP_foamStar=data{:,2:end};

SWENSEfullfile=fullfile(SWENSEfile,'/probes/0/p')
data1=readtable(SWENSEfullfile);

dt_PP_S=data1{:,1};
PP_SWENSE=data1{:,2:end};




for i=2:8
    
    PP1_foamStarA=PP_foamStar(:,i);
    PP1_SWENSE=PP_SWENSE(:,i);
     
    Expt_yaxis=PP_Expt(ExptPressureIndices,i);
    IExpt_yaxis=interp1(pl_timeB,Expt_yaxis,dt_PP,'cubic');
    
    PP1_foamStarB=(PP1_foamStarA)*0.01-PP_static(i);  % Converting kg/ms2 to mbar
    IPP1_foamStarB=interp1(dt_PP,PP1_foamStarB,dt_PP,'cubic');
    
    PP1_SWENSEB=(PP1_SWENSE).*0.01-PP_static(i);  % Converting kg/ms2 to mbar
    IPP1_SWENSEB=interp1(dt_PP_S,PP1_SWENSEB,dt_PP,'cubic');
    
   Error=[IPP1_foamStarB IPP1_SWENSEB];
   dt=dt_PP(2)-dt_PP(1);
   %% Estimation single value in the Cross Correlation in Experiment 
   for k=1:2
   [r(:,k),lags(:,k)]=xcorr(Error(:,k),IExpt_yaxis,'coeff');
    [~,I(:,k)]=max(abs(r(:,k)));
    Lag(:,k)=lags(I(:,k));
    Q3(k)=max(abs(r(:,k)));
   end    
   %% Estimation single  value in the Cross correlation in foamStar and SWENSE
   
      for j=1:2
        Q4(i-1,j)=Q3(j);
      end
      
   FigH = figure('Position', get(0, 'Screensize'));
   % figure()
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
% fontsize = 18;

   for j=1:2
    plot(ccost(j),Q3(j),'d','MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(j,:)) 
    % plot(cost2D(:,hhh),ampli(fi,:,hhh),[markerSet(hhh)],'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(hhh,:))
    %set(gca, 'XScale', 'log', 'YScale', 'log');
 
  
    set(gca,'fontsize',fontsize)
    ylim1 = [10^(-0.02) 10^(0)];
%     ytick1 = [10^(-2) 10^(-1) 1.0 ];  
    ylim(ylim1)
%     set(gca,'Ytick',ytick1)
    xlim([10^4 10^6])
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    % set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
%     set(gca,'ygrid','on','gridlinestyle','-')
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
   % set(gcf,'Units','Centimeter','OuterPosition',rect3)
    % set(gca,'tickLabelInterpreter','latex')
    
    ylabalis =sprintf('Cross Correlation  Coefficient');
    ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
    
    xlabalis =sprintf('Computational cost (s)');
    xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
    hold on
   end     
       
       % saveas(FigH, ['PP ',num2str(i)],'png');
        hold off
        legend ('foamStar','SWENSE CoarseMesh','FontSize',32);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['PP ',num2str(i) ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
    fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/CrossCorrleationError/';
    saveas(FigH, fullfile(fname, ['PP ',num2str(i)]), 'jpeg');
   
end

   %% Finding the mean  of error and computational cost
    meanfoamStar=Q4(:,1);
    meanSWENSE=Q4(:,2);
    Overallmean=[mean(meanfoamStar) mean(meanSWENSE)];
    
    FigH = figure('Position', get(0, 'Screensize'));
     for j=1:2
    plot(ccost(j),Overallmean(j),'d','MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(j,:))  
  
    set(gca,'fontsize',fontsize)
    ylim1 = [10^(-0.01) 10^(0)];
    ylim(ylim1)
    xlim([10^4 10^6])
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')    
    ylabalis =sprintf('Cross Correlation  Coefficient');
    ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
    
    xlabalis =sprintf('Computational cost (s)');
    xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
    hold on
   end     
       
        hold off
        legend ('foamStar','SWENSE CoarseMesh','FontSize',32);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['Pressure Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
      fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/CrossCorrleationError/';
    saveas(FigH, fullfile(fname, ['PPmean ']), 'jpeg');
