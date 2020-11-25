function foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static)

%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)

PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

%Selection time 5s to 35s overall. with constant phase shift is reduced

pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=pp2(ExptPressureIndices,1);
pl_timeB=pl_timeA-pl_timeA(1)-cps; %

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
    PP1_foamStarB=(PP1_foamStarA)*0.01-PP_static(i);  % Converting kg/ms2 to mbar
    PP1_SWENSEB=(PP1_SWENSE).*0.01-PP_static(i);  % Converting kg/ms2 to mbar

    figure()
    plot(dt_PP,PP1_foamStarB,'LineWidth',3)
    hold on 
    plot(dt_PP_S,PP1_SWENSEB,'LineWidth',3) 
    hold on
    plot(pl_timeB,Expt_yaxis,'LineWidth',3)
    xlim([0.05 5])
    ylabel('Dynamic Pressure [mBar]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['PP ',num2str(i)],'FontSize',32)
    legend ('foamStar','SWENSE','Experiment','FontSize',32);
    grid on;
end

 
