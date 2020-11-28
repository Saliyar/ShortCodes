function foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps)

%% Code to check the Surface elevation probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)


WP_Expt=[wp5(:,2) wp6(:,2) wp7(:,2)];

pl_timeWA=wp5(ExptPressureIndices,1);
pl_timeWB=pl_timeWA-pl_timeWA(1);



foamStarfullfile=fullfile(foamStarfile,'waveProbe/0/surfaceElevation.dat')
data=readtable(foamStarfullfile);

dt_foamStar1=data{:,1}+cps;
Eta_foamStar1=data{:,2:end};



SWENSEfullfile=fullfile(SWENSEfile,'waveProbe/0/surfaceElevation.dat')
data1=readtable(SWENSEfullfile);

dt_SWENSE1=data1{:,1}+cps;
Eta_SWENSE1=data1{:,2:end};




for i=1:3
    j=i+4;
    Y_axis1=Eta_foamStar1(:,i);
    Y_axis2=Eta_SWENSE1(:,i);
    Expt_yaxis=WP_Expt(ExptPressureIndices,i);

figure()
    plot(dt_foamStar1,Y_axis1,'LineWidth',3)
    hold on;
    plot(dt_SWENSE1,Y_axis2,'LineWidth',3)
    hold on;
    plot(pl_timeWB,Expt_yaxis,'LineWidth',3)
    xlim([0.05 5])
    ylabel('surface elevation [m]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['WP ',num2str(j)],'FontSize',32)
    legend ('foamStar','SWENSE','Experiment','FontSize',32);
    grid on;

end
