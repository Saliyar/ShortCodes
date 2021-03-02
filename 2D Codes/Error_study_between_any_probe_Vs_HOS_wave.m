%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code for compary any probe case for cmparing with HOS wave
% for specific time interval

clc
close all
clear

%% Getting details of HOS wave

data_HOS=readtable('/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/HOS Wave probe details/probes1.dat');
% Six wave probes are placed - 3 far from the Cylinder last 3 infront, at
% and behind the cylinder - Mostly comparing 4th probe
probe_HOS=5;

dt_HOS=data_HOS{:,1};
Eta_HOS=data_HOS{:,2:end};

%Specifying Time interval
Time_index=find(data_HOS{:,1}>37 & data_HOS{:,1}<42);

dt_HOS1=dt_HOS(:,1);
dt_HOS2=dt_HOS1-dt_HOS1(1);
Y_axis_HOS=Eta_HOS(:,probe_HOS);

plot(dt_HOS2,Y_axis_HOS,'LineWidth',2)
hold on


%% Loading details from the Test case
probe_cfd=1;

data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo0.1/postProcessing/waveProbe/0/surfaceElevation.dat');

Eta_foamStar1=data1{:,2:end};
Time_index=find(data1{:,1}>37 & data1{:,1}<42);

%Obtaining time step from the given
dt_1=data1{:,1};
% dt1=data1{Time_index,1};
dt_foamStar1=dt_1-dt_1(1);
Eta_foamStar_extracted_window1=Eta_foamStar1(:,probe_cfd);

plot(dt_foamStar1,Eta_foamStar_extracted_window1,'LineWidth',2)
legend('HOS','foamStar 3D')
xlim([38 40])
hold off