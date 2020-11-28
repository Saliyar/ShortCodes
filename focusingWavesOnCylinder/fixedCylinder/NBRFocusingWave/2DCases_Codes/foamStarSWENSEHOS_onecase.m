function foamStarSWENSEHOS_onecase()

%% Code to check the Pressure probe results between foamStar and foamStar
close all
clc 
clear

%% Experimental results
data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx25MeshCo1/postProcessing/waveProbe/0/surfaceElevation.dat');
data2=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/SWENSE_2D_Check/SWENSE_Mesh25Co0.5/postProcessing/waveProbe/0/surfaceElevation.dat');
data_HOS=readtable('/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/HOS Wave probe details/probes1.dat');


dt_foamStar1=data1{:,1};
Eta_foamStar1=data1{:,2:end};

dt_foamStar2=data2{:,1};
Eta_foamStar2=data2{:,2:end};

%% Index for HOSplot(dt_foamStar1,Y_axis1,'LineWidth',2)
probe_HOS=6;
probe_CFD=2;

%% HOS file processing
dt_HOS=data_HOS{:,1};
dt_HOS1=dt_HOS-dt_HOS(1);
Eta_HOS=data_HOS{:,2:end};


i=probe_CFD;
Y_axis1=interp1(dt_foamStar1,Eta_foamStar1(:,i),dt_foamStar2,'spline');
Y_axis2=interp1(dt_foamStar2,Eta_foamStar2(:,i),dt_foamStar2,'spline');

Y_axis_HOS=interp1(dt_HOS1,Eta_HOS(:,probe_HOS),dt_foamStar2,'spline');
Y_axis=[Y_axis1 Y_axis2 Y_axis_HOS];


%Problem for estimating the lags
dt=dt_foamStar2(2)-dt_foamStar2(1);
dt_waveplot=dt_foamStar2;

figure()

for i=1:3
plot(dt_waveplot,Y_axis(:,i),'LineWidth',2)
hold on;
xlim([35 45])
ylabel('surface elevation [m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
% legend ('foamStar1','foamStar2','foamStar3','foamStar4','foamStar5','HOS','FontSize',32);

grid on;
end
legend ('foamStar Wave','SWENSE Wave','HOS','FontSize',32);
hold off;
