function movfoamStarExpt_pressure(Exptpressurepath,ExptIndices,foamStarmovgenfile,cps,PP_static,nStart,nEnd)

%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)
% Channel 1 - Time
% Channel 2 - PP 7 
% Channel 3 - PP8 
% Channel 4 - PP 2 
% Channel 5 - PP 5
% Channel 6 - PP 3
% Channel 7 - PP 1
% Channel 8 - PP 4 
% Channel 9 - PP 6 

Expt_time=Channel_1_Data;
PP_Expt=[Channel_7_Data(:,1) Channel_4_Data(:,1) Channel_6_Data(:,1) Channel_8_Data(:,1) Channel_5_Data(:,1) Channel_9_Data(:,1) Channel_2_Data(:,1) Channel_3_Data(:,1)];


%% Plot - Uncomment if required
% plot(Expt_time,Expt_force_N,'LineWidth',3);
% ylabel('Force(N)','FontSize',32)
% xlabel('Time [s]','FontSize',32)
% set(gca,'Fontsize',32)
% title('Experimental Force' ,'FontSize',32)
% % legend ('foamStar','Experiment','FontSize',32);
% grid on;

%Selection time 5s to 35s overall. with constant phase shift is reduced

% pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=Expt_time(ExptIndices,1);

for i=1:8
    Expt_yaxis1=PP_Expt(:,i);
    yaxis= Expt_yaxis1(ExptIndices,1);
    [Expt_yaxis1]=filterTimeSeries(yaxis);
    close all
    Expt_yaxis_filtered(:,i)= Expt_yaxis1;
end
pl_timeB=pl_timeA-pl_timeA(1)-cps; %



%% foamStar comparision

for j=1:8
    figure()
    for i=nStart:nEnd
            FileName=[foamStarmovgenfile,num2str(i)]
            foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p1');
            data=readtable(foamStarfullfile);
            dt_PP=data{:,1};
            PP_foamStar=data{:,j+1};
            PP1_foamStarB=(PP_foamStar)*0.01;  % Converting kg/ms2 to mbar
            
            plot(dt_PP,PP1_foamStarB,'LineWidth',3)
            hold on 
    
end
plot(pl_timeB,Expt_yaxis_filtered(:,j),'LineWidth',3)
    xlim([0.05 15])
    ylabel('Dynamic Pressure [mBar]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['PP ',num2str(j)],'FontSize',32)
    grid on;
    legend ('foamStar-Coarse-Euler','foamStar-Medium-Euler','Experiment','FontSize',32);
end

 
