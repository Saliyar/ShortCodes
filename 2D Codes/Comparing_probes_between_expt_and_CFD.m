%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code for Comparing Experimenetal wave and pressure probes with foamStar probes
%Loading experimental data
clear
clc
close all
load('/home/saliyar/Documents/My_codes/catA_23003.mat')

PP_Sriram=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];
%Selection time 5s to 35s overall. 
indices=3702:4201;
pl_timeA=pp2(indices,1);
pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeB=pl_timeA-pl_timeA(1); 
WP_Sriram=[wp5(:,2) wp6(:,2) wp7(:,2)];

pl_timeWA=wp5(indices,1);
pl_timeWB=pl_timeA-pl_timeA(1);

%% Pressure probes comparision
data=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/postProcessing/probes/0/p');
dt_PP=data{:,1}+0.185;
PP_foamStar=data{:,2:end};
PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];
for i=2:8
PP1_foamStarA=PP_foamStar(:,i);

Expt_yaxis=PP_Sriram(indices,i);
PP1_foamStarB=(PP1_foamStarA)*0.01-PP_static(i);  % Converting kg/ms2 to mbar


figure()
plot(dt_PP,PP1_foamStarB,'LineWidth',2)
hold on 
plot(pl_timeB,Expt_yaxis,'LineWidth',2)
xlim([0.05 5])
ylabel('Dynamic Pressure [mBar]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title(['PP ',num2str(i)],'FontSize',32)
 legend ('foamStar','Experiment','FontSize',32);
 grid on;
end

 
%% Wave probe comparision
data=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/postProcessing/waveProbe/0/surfaceElevation.dat');
dt_foamStar1=data{:,1}+0.185;
Eta_foamStar1=data{:,2:end};

for i=1:3
j=i+4;
Y_axis1=Eta_foamStar1(:,i);

Expt_yaxis=WP_Sriram(indices,i);
figure()
plot(dt_foamStar1,Y_axis1,'LineWidth',1)
hold on;

plot(pl_timeWB,Expt_yaxis,'LineWidth',1)
xlim([0.05 5])
ylabel('surface elevation [m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title(['WP ',num2str(j)],'FontSize',32)
legend ('foamStar','Experiment','FontSize',32);
grid on;

end