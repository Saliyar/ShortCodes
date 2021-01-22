function Ncases_foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,lgd)

load(Exptpressurepath)


WP_Expt=[wp5(:,2) wp6(:,2) wp7(:,2)];

pl_timeWA=wp5(ExptPressureIndices,1);
pl_timeWB=pl_timeWA-pl_timeWA(1)-cps;

%% FoamStar loading

for k=1:numfoamStar
    FileName=[BaseName_foamStar,num2str(k)]
    foamStarfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
    data=readtable(foamStarfullfile);
    
    %Finding Indexes
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    foamStar_dtWP(:,k)=data{start_idx:end_idx,1};
    WP_foamStar=data{start_idx:end_idx,2:end};
            for wp=1:3
                foamStar_WP(:,wp,k) = WP_foamStar(:,wp);
            end
end


for k=1:nSWENSE
    FileName=[BaseName_SWENSE,num2str(k)]
    SWENSEfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
    data=readtable(SWENSEfullfile);
    
    %Finding Indexes
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    SWENSE_dtWP(:,k)=data{start_idx:end_idx,1};
    WP_SWENSE=data{start_idx:end_idx,2:end};
            for wp=1:3
                SWENSE_WP(:,wp,k) = WP_SWENSE(:,wp);
            end
end


for i=1:3
    FigH = figure('Position', get(0, 'Screensize'));
    
        Expt_yaxis=WP_Expt(ExptPressureIndices,i);
        plot(pl_timeWB,Expt_yaxis,'LineWidth',3)
        hold on
 %% FoamStar cases loading  ...    
 
 for k=1:numfoamStar
     plot(foamStar_dtWP(:,k),foamStar_WP(:,i,k),'LineWidth',3);     
    hold on 
 end
 hold on
  for k=1:nSWENSE
     plot(SWENSE_dtWP(:,k),SWENSE_WP(:,i,k),'LineWidth',3);     
    hold on 
  end
    
    xlim([1.2 2.5])
    ylabel('surface elevation [m]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['WP ',num2str(i+4)],'FontSize',32)
    % legend ('Experiment','foamStar1','foamStar2','SWENSE1','SWENSE2','FontSize',32);
    legend (lgd{:},'interpreter','latex','FontSize',32,'Location','northeast','NumColumns',2);
    grid on;
    hold off
    saveas(FigH, ['WP ',num2str(i+4)],'png');
end
