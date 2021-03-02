%% Code to check the Pressure probe results between foamStar and foamStar
close all
clc 
clear

%% Experimental results
data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo1/postProcessing/waveProbe/0/surfaceElevation.dat');
data2=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo0.75/postProcessing/waveProbe/0/surfaceElevation.dat');
data3=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo0.5/postProcessing/waveProbe/0/surfaceElevation.dat');
data4=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo0.25/postProcessing/waveProbe/0/surfaceElevation.dat');
data5=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx10MeshCo0.1/postProcessing/waveProbe/0/surfaceElevation.dat');

data_HOS=readtable('/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/HOS Wave probe details/probes1.dat');


dt_foamStar1=data1{:,1};
Eta_foamStar1=data1{:,2:end};

dt_foamStar2=data2{:,1};
Eta_foamStar2=data2{:,2:end};

dt_foamStar3=data3{:,1};
Eta_foamStar3=data3{:,2:end};

dt_foamStar4=data4{:,1};
Eta_foamStar4=data4{:,2:end};

dt_foamStar5=data5{:,1};
Eta_foamStar5=data5{:,2:end};

% dt_foamStar6=data6{:,1};
% Eta_foamStar6=data6{:,2:end};


%% Index for HOSplot(dt_foamStar1,Y_axis1,'LineWidth',2)
probe_HOS=6;
probe_CFD=2;

%% HOS file processing
dt_HOS=data_HOS{:,1};
dt_HOS1=dt_HOS-dt_HOS(1);
Eta_HOS=data_HOS{:,2:end};

%% Interpolating all the test cases for single vector length
i=probe_CFD;
Y_axis1=interp1(dt_foamStar1,Eta_foamStar1(:,i),dt_foamStar5,'spline');
Y_axis2=interp1(dt_foamStar2,Eta_foamStar2(:,i),dt_foamStar5,'spline');
Y_axis3=interp1(dt_foamStar3,Eta_foamStar3(:,i),dt_foamStar5,'spline');
Y_axis4=interp1(dt_foamStar4,Eta_foamStar4(:,i),dt_foamStar5,'spline');
Y_axis5=Eta_foamStar5(:,i);
Y_axis_HOS=interp1(dt_HOS1,Eta_HOS(:,probe_HOS),dt_foamStar5,'spline');
Y_axis=[Y_axis1 Y_axis2 Y_axis3 Y_axis4 Y_axis5 Y_axis_HOS];

%Problem for estimating the lags
dt=dt_foamStar5(2)-dt_foamStar5(1);
dt_waveplot=dt_foamStar5;

figure()

for i=1:6
plot(dt_waveplot,Y_axis(:,i),'LineWidth',2)
hold on;
xlim([35 45])
ylabel('surface elevation [m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
% legend ('foamStar1','foamStar2','foamStar3','foamStar4','foamStar5','HOS','FontSize',32);

grid on;
end
legend ('Dx10Co 1','Dx10Co 0.75','Dx10Co 0.5','Dx10Co 0.25','Dx10Co 0.1','HOS','FontSize',32);
hold off;
%% Estimating Cross Correlation between the Wave forms
% xcorr returns 2*length of the longest vector-1 lags by default 
for i=1:5
    [r(:,i),lags(:,i)]=xcorr(Y_axis(:,i),Y_axis_HOS,'coeff');
    [~,I(:,i)]=max(abs(r(:,i)));
    Lag(:,i)=lags(I(:,i));
    rmax(i)=max(abs(r(:,i)));
end

%% Plot the Cross Correlation between finesh mesh with HOS wave
figure()
stem(lags(:,5),r(:,5))
xlabel('Time lag','FontSize',32)
ylabel('Cross Correlation','FontSize',32)
set(gca,'Fontsize',32)
xr=[1 2 3 4 5];
%% Plot for Phase shift estimation 
figure()

plot(xr,Lag*dt,'-o','LineWidth',3)
xticks([1 2 3 4 5])
xticklabels({'Co1','Co0.75','Co0.5','Co0.25','Co0.1'})
xtickangle(45)
% xlabel('Phase difference between HOS and other simulations','FontSize',32)
ylabel('Phase shift(s)','FontSize',32)
set(gca,'Fontsize',32)
grid on;

%% Plot the Cross correlation maximum coefficient
figure()

plot(xr,rmax,'-o','LineWidth',3)

xlabel('Courant number','FontSize',32)
ylabel('Cross Correlation Coefficient','FontSize',32)

set(gca,'Fontsize',32)
xticks([1 2 3 4 5])
xticklabels({'Co1','Co0.75','Co0.5','Co0.25','Co0.1'})
xtickangle(45)
grid on;






