function ErrorSurfaceElevation(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs)

%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)

WP_Expt=[wp5(:,2) wp6(:,2) wp7(:,2)];

pl_timeA=wp5(ExptPressureIndices,1);
pl_timeB=pl_timeA-pl_timeA(1)-cps;


Q4=0;

%% foamStar data reading

for k=1:numfoamStar
    FileName=[BaseName_foamStar,num2str(k)]
    foamStarfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
    data=readtable(foamStarfullfile);
    
    %Finding Indexes
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    foamStar_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_foamStar=data{start_idx:end_idx,2:end};
            for pp=1:3
                foamStar_PP(:,pp,k) = PP_foamStar(:,pp);
                
            end
end

%% SWENSE data reading
for k=1:nSWENSE
    FileName=[BaseName_SWENSE,num2str(k)]
    SWENSEfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
    data=readtable(SWENSEfullfile);
    
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    
    SWENSE_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_SWENSE=data{start_idx:end_idx,2:end};
    
        for pp=1:3
            SWENSE_PP(:,pp,k) = PP_SWENSE(:,pp);
        end
end

%% Setting Interpolation parameter
dt_PP=foamStar_dtPP(:,2); % Case 2 was least time with 2.5s for now


%% Starting Pressure sensor values 
for i=1:3
    Expt_yaxis=WP_Expt(ExptPressureIndices,i);
    IExpt_yaxis=interp1(pl_timeB,Expt_yaxis,dt_PP,'cubic');
% Interpolating Pressure sensor values     
    for k=1:numfoamStar
    PP1_foamStarA=foamStar_PP(:,i,k);   
    PP1_foamStarB=(PP1_foamStarA);  % Converting kg/ms2 to mbar
    IP_Timeseries(:,k)=interp1(foamStar_dtPP(:,k),PP1_foamStarB,dt_PP,'cubic');
     end
% Interpolating SWENSE values  
  for k=1:nSWENSE
     PP1_SWENSE=SWENSE_PP(:,i,k);   
    PP1_SWENSEB=(PP1_SWENSE);  % Converting kg/ms2 to mbar
    IP_Timeseries(:,k+numfoamStar)=interp1(SWENSE_dtPP(:,k),PP1_SWENSEB,dt_PP,'cubic'); 
  end
 %% Club all the numerical timeseries 
  
   Error=IP_Timeseries;

   dt=dt_PP(2)-dt_PP(1);

   %% Estimation single value in the Cross Correlation in Experiment 
   for k=1:numfoamStar+nSWENSE
   [r(:,k),lags(:,k)]=xcorr(Error(:,k),IExpt_yaxis,'coeff');
    [~,I(:,k)]=max(abs(r(:,k)));
    Lag(:,k)=lags(I(:,k));
    Q3(k)=max(abs(r(:,k)));
   end    
   %% Estimation single  value in the Cross correlation in foamStar and SWENSE
   
      for j=1:numfoamStar+nSWENSE
        Q4(i,j)=Q3(j);
      end
    
%% plotting the Error Graph    
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

   for j=1:numfoamStar+nSWENSE
   if(j<=numfoamStar-1)
           Gtype=1;
       else
           Gtype=2;
       end
    plot(ccost(j),Q3(j),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(j,:)) 
    % plot(cost2D(:,hhh),ampli(fi,:,hhh),[markerSet(hhh)],'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(hhh,:))
    %set(gca, 'XScale', 'log', 'YScale', 'log');
 
  
    set(gca,'fontsize',fontsize)
    ylim1 = [10^(-0.03) 10^(0)];
%     ytick1 = [10^(-2) 10^(-1) 1.0 ];  
    ylim(ylim1)
%     set(gca,'Ytick',ytick1)
    xlim([10^3 10^7])
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
       
       % saveas(FigH, ['WP ',num2str(i+4)],'png');
        hold off
     legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['WP ',num2str(i+4) ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
    % saveas(FigH, ['PP ',num2str(i)],'png');
    
%    fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/SurfaceElevationError/CrossCorrleationError/';
%     saveas(FigH, fullfile(fname, ['WP ',num2str(i+4)]), 'jpeg');
   
end

   %% Finding the mean  of error and computational cost
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


  for i=1:numfoamStar+nSWENSE  
      
       if(i<=numfoamStar)
           Gtype=1;
           k=i;
       else
           Gtype=2;
           k=i+1;
      end
    plot(ccost(k),mean(Q4(:,i)),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(i,:))  
    
    set(gca,'fontsize',fontsize)
 ylim1 = [10^(-0.03) 10^(0)];
%     ytick1 = [10^(-2) 10^(-1) 1.0 ];  
    ylim(ylim1)
%     set(gca,'Ytick',ytick1)
    xlim([10^3 10^7])
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
            legend ('fsB-F','fsS-F','fsS-M','SwB-F','SwS-F','SwS-M','SwS-C','interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['Wave Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
%     fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/SurfaceElevationError/CrossCorrleationError/';
%     saveas(FigH, fullfile(fname, ['WPmean ']), 'jpeg');
    