function foamStarSWENSEExpt_pressure()

%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load('catA_23003.mat')
PP_Sriram=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];
%Selection time 5s to 35s overall. with constant phase shif is reduced
%38.17s it starts
indices=3702:4202;
pl_timeA=pp2(indices,1);
pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeB=pl_timeA-pl_timeA(1)-0.14; % Phase shift suggested by Shagun only implied
WP_Sriram=[wp5(:,2) wp6(:,2) wp7(:,2)];

pl_timeWA=wp5(indices,1);
pl_timeWB=pl_timeA-pl_timeA(1);


%% foamStar and foamStar SWENSE comparision
data=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/3D_Wave_only_case/From_scratch/foamStar_NBR_fixed_trial_final/postProcessing/probes/0/p');
data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/3D_Wave_only_case/From_scratch/foamStar_NBR_fixed_trial_final/postProcessing/probes/0/p');
dt_PP=data{:,1};dt_PP_S=data1{:,1};
PP_foamStar=data{:,2:end};PP_SWENSE=data1{:,2:end};
PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];
for i=2:8
PP1_foamStarA=PP_foamStar(:,i);
PP1_SWENSE=PP_SWENSE(:,i);
Expt_yaxis=PP_Sriram(indices,i);
PP1_foamStarB=(PP1_foamStarA)*0.01-PP_static(i);  % Converting kg/ms2 to mbar
PP1_SWENSEB=(PP1_SWENSE).*0.01-PP_static(i);  % Converting kg/ms2 to mbar

figure()
plot(dt_PP,PP1_foamStarB,'LineWidth',3)
hold on 
% plot(dt_PP_S,PP1_SWENSEB,'LineWidth',3) hold on
plot(pl_timeB,Expt_yaxis,'LineWidth',3)
xlim([0.05 5])
ylabel('Dynamic Pressure [mBar]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title(['PP ',num2str(i)],'FontSize',32)
 legend ('foamStar','SWENSE','Experiment','FontSize',32);
 grid on;
end

 
%% Experimental results
data=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/3D_Wave_only_case/From_scratch/foamStar_NBR_fixed_trial_final/postProcessing/waveProbe/0/surfaceElevation.dat');
data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/3D_Wave_only_case/From_scratch/foamStar_NBR_fixed_trial_final/postProcessing/probes/0/p');
dt_foamStar1=data{:,1}+0.1;
Eta_foamStar1=data{:,2:end};

dt_SWENSE1=data1{:,1}-0.15;
Eta_SWENSE1=data1{:,2:end};

for i=1:3
j=i+4;
Y_axis1=Eta_foamStar1(:,i);
Y_axis2=Eta_SWENSE1(:,i);
Expt_yaxis=WP_Sriram(indices,i);
figure()
plot(dt_foamStar1,Y_axis1,'LineWidth',3)
hold on;
% plot(dt_SWENSE1,Y_axis2,'LineWidth',3) hold on;
plot(pl_timeB,Expt_yaxis,'LineWidth',3)
xlim([0.05 5])
ylabel('surface elevation [m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title(['WP ',num2str(j)],'FontSize',32)
legend ('foamStar','Experiment','FontSize',32);
grid on;

end
