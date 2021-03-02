%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparing the focussing wave variation - for different initial time and
% duration of time
clear
close all
clc

%% Loading all the parameters required
data1=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/InitialTime_study/foamStar2D_Dx25MeshCo0.5_fullsimulation/postProcessing/waveProbe/0/surfaceElevation.dat');
data2=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/InitialTime_study/foamStar2D_Dx25MeshCo0.5_5s_duration_time/postProcessing/waveProbe/0/surfaceElevation.dat');
data3=readtable('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/InitialTime_study/foamStar2D_Dx25MeshCo0.5_1s_duration_time/postProcessing/waveProbe/0/surfaceElevation.dat');

%% Chosen probe for comparision
probe_cfd=1;


%% Loading data for full 50s simulation - take data of 37.5s-38.5s and make it zero 

Eta_foamStar1=data1{:,2:end};
Time_index=find(data1{:,1}>37.5 & data1{:,1}<40.5);

%Obtaining time step from the given
dt_1=data1{:,1};
dt1=data1{Time_index,1};
dt_foamStar1=dt1-dt1(1);
Eta_foamStar_extracted_window1=Eta_foamStar1(Time_index,probe_cfd);

plot(dt_foamStar1,Eta_foamStar_extracted_window1,'LineWidth',2)
hold on

%% Loading data for 5s simulation 
Eta_foamStar2=data2{:,2:end};
Time_index=find(data2{:,1}>0 & data2{:,1}<3);

%Obtaining time step from the given 
dt_2=data2{:,1};
dt2=data2{Time_index,1};
dt_foamStar2=dt2-dt2(1);
Eta_foamStar_extracted_window2=Eta_foamStar2(Time_index,probe_cfd);

plot(dt_foamStar2,Eta_foamStar_extracted_window2,'-s','LineWidth',2)
hold on

%% Loading data for 1s simulation 
Eta_foamStar3=data3{:,2:end};

%Obtaining time step from the given 
dt3=data3{:,1};
dt_foamStar3=dt3-dt3(1);
Eta_foamStar_extracted_window3=Eta_foamStar3(:,probe_cfd);

plot(dt_foamStar3,Eta_foamStar_extracted_window3,'-*','LineWidth',2)
ylabel('Wave surface elevation[m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
legend('[0s 50s] -50s simulation','[37s 42s]-5s simulation','[37.5s-38.5s]-1s simulation')
grid on;
hold off
