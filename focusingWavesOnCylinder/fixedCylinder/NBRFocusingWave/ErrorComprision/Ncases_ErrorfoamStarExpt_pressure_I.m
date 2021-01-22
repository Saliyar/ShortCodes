function Ncases_ErrorfoamStarExpt_pressure_I(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs)


%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)

PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

%Selection time 5s to 35s overall. with constant phase shift is reduced

pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=pp2(ExptPressureIndices,1);
pl_timeB=pl_timeA-pl_timeA(1)-cps; %
Q4=0;

%% foamStar data reading

for k=1:numfoamStar
    FileName=[BaseName_foamStar,num2str(k)]
    foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
    data=readtable(foamStarfullfile);
    
    %Finding Indexes
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    foamStar_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_foamStar=data{start_idx:end_idx,2:end};
            for pp=2:8
                foamStar_PP(:,pp,k) = PP_foamStar(:,pp)*0.01-PP_static(pp);
                
            end
end

%% SWENSE data reading
for k=1:nSWENSE
    FileName=[BaseName_SWENSE,num2str(k)]
    SWENSEfullfile=fullfile(FileName,'postProcessing/probes/0/p')
    data=readtable(SWENSEfullfile);
    
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    
    SWENSE_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_SWENSE=data{start_idx:end_idx,2:end};
    
        for pp=2:8
            SWENSE_PP(:,pp,k) = PP_SWENSE(:,pp)*0.01-PP_static(pp);
        end
end

%% Setting Interpolation parameter
dt_PP=foamStar_dtPP(:,2); % Case 2 was least time with 2.5s for now


%% Starting Pressure sensor values 
for i=2:8
    Expt_yaxis=PP_Expt(ExptPressureIndices,i);
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
 %% Error Estimation begins
    
    Q2=trapz(dt_PP,abs(IExpt_yaxis)); %Experimental area
    
      for j=1:numfoamStar+nSWENSE
        Q1(j)=trapz(dt_PP,abs(Error(:,j)));
        Q3(j)=abs((Q2-Q1(j))/Q2)
        Q4(i-1,j)=Q3(j);
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
       if(j<=numfoamStar)
           Gtype=1;
       else
           Gtype=2;
       end
    plot(ccost(j),Q3(j),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(j,:)) 
    % plot(cost2D(:,hhh),ampli(fi,:,hhh),[markerSet(hhh)],'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(hhh,:))
    %set(gca, 'XScale', 'log', 'YScale', 'log');
 
  
    set(gca,'fontsize',fontsize)
   ylim1 = [10^(-3) 10^(0)];
%     ytick1 = [10^(-2) 10^(-1) 1.0 ];  
    ylim(ylim1)
%     set(gca,'Ytick',ytick1)
   xlim([10^2 10^7])
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    % set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
%     set(gca,'ygrid','on','gridlinestyle','-')
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
   % set(gcf,'Units','Centimeter','OuterPosition',rect3)
    % set(gca,'tickLabelInterpreter','latex')
    
    ylabalis =sprintf('Normalized error');
    ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
    
    xlabalis =sprintf('Computational cost (s)');
    xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
    hold on
   end     
       
       % saveas(FigH, ['PP ',num2str(i)],'png');
        hold off
     legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['PP ',num2str(i) ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
    % saveas(FigH, ['PP ',num2str(i)],'png');
    
   fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/AreaComparisionError/';
    saveas(FigH, fullfile(fname, ['PP ',num2str(i)]), 'jpeg');
   
end

   %% Finding the mean  of error and computational cost
 FigH = figure('Position', get(0, 'Screensize'));
  for i=1:numfoamStar+nSWENSE  
   if(i<=numfoamStar)
           Gtype=1;
       else
           Gtype=2;
      end
    plot(ccost(i),mean(Q4(:,i)),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(i,:))  
    set(gca,'fontsize',fontsize)
    ylim1 = [10^(-3) 10^(0)];
    ylim(ylim1)
    xlim([10^3 10^6])
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')    
    ylabalis =sprintf('Normalized error');
    ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
    
    xlabalis =sprintf('Computational cost (s)');
    xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
    hold on
  end 
       
        hold off
      legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
    title(['Pressure Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
    % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
    fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/AreaComparisionError/';
    saveas(FigH, fullfile(fname, ['PPmean ']), 'jpeg');
    
    