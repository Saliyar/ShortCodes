%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This Code is to compare the pressure sensor results in the case of moving 
% Cylindr with experimental results%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function movfoamStarExpt_compPressure(foamStarfile1,foamStarfile2,cps,PP_static,Exptpressurepath,ExptPressureIndices)

load(Exptpressurepath)

PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

%Selection time 5s to 35s overall. with constant phase shift is reduced

pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=pp2(ExptPressureIndices,1);
pl_timeB=pl_timeA-pl_timeA(1)-cps; %

%% foamStar and foamStar SWENSE comparision

foamStarfullfile1=fullfile(foamStarfile1,'/probes/0/p')
data1=readtable(foamStarfullfile1);
dt_PP1=data1{:,1};
PP_foamStar1=data1{:,2:end};


foamStarfullfile2=fullfile(foamStarfile2,'/probes/0/p')
data2=readtable(foamStarfullfile2);
dt_PP2=data2{:,1};
PP_foamStar2=data2{:,2:end};




for i=2:8
    
    PP1_foamStarA=PP_foamStar1(:,i).*0.01-PP_static(i);
    PP2_foamStarA=PP_foamStar2(:,i).*0.01-PP_static(i);
    Expt_yaxis=PP_Expt(ExptPressureIndices,i);

    FigH = figure('Position', get(0, 'Screensize'));
    plot(dt_PP1,PP1_foamStarA,'LineWidth',3)
    hold on 
    plot(dt_PP2,PP2_foamStarA,'LineWidth',3) 
    hold on
    plot(pl_timeB,Expt_yaxis,'LineWidth',3)
    xlim([0.05 4])
    ylabel('Dynamic Pressure [mBar]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['PP ',num2str(i)],'FontSize',32)
    legend ('BlockMesh','SnappyHexMesh','Experiment','FontSize',32);
    grid on;
    
    saveas(FigH, ['PP ',num2str(i)],'png');

end

 
