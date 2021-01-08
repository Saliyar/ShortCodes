function movfoamStarExpt_compSurfaceElevation(foamStarfile1,foamStarfile2,cps,Exptpressurepath,ExptPressureIndices)


%% Loading Experimental details
load(Exptpressurepath)
WP_Expt=[wp5(:,2) wp6(:,2) wp7(:,2)];
pl_timeWA=wp5(ExptPressureIndices,1);
pl_timeWB=pl_timeWA-pl_timeWA(1);


%% Loading First foamStar file

foamStarfullfile1=fullfile(foamStarfile1,'waveProbe/0/surfaceElevation.dat')
data=readtable(foamStarfullfile1);
dt_foamStar1=data{:,1}+cps;
Eta_foamStar1=data{:,2:end};

foamStarfullfile2=fullfile(foamStarfile2,'waveProbe/0/surfaceElevation.dat')
data=readtable(foamStarfullfile2);
dt_foamStar2=data{:,1}+cps;
Eta_foamStar2=data{:,2:end};



for i=1:3
    j=i+4;
    Y_axis1=Eta_foamStar1(:,i);
    Y_axis2=Eta_foamStar2(:,i);
    Expt_yaxis=WP_Expt(ExptPressureIndices,i);

    FigH = figure('Position', get(0, 'Screensize'));
    plot(dt_foamStar1,Y_axis1,'LineWidth',3)
    hold on;
    plot(dt_foamStar2,Y_axis2,'LineWidth',3)
    hold on;
    plot(pl_timeWB,Expt_yaxis,'LineWidth',3)
    xlim([0.05 4])
    ylabel('surface elevation [m]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['WP ',num2str(j)],'FontSize',32)
    legend ('BlockMesh','SnappyHexMesh','Experiment','FontSize',32);
    grid on;
    saveas(FigH, ['WP ',num2str(i)],'png');

end
