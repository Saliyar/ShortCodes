%% Code to understand the influence of z variation in the focussing wave case
%% Wave probe comparision for Relaxation zone study
%% Outlet
clc
close all
clear
%% Basic inputs
probe_location_cfd=4;
probe_location_HOS=7;
n=1 ;% Number of iteration

VarCo = {'0.5'};
VarDelta={'25'};
Var_H={'25','50','75','100'};

%% Step 2: Loading the HOS files inside

data_HOS=readtable('/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/HOS Wave probe details/probes1.dat');
%%HOS file processing
dt_HOS=data_HOS{:,1};
Eta_HOS=data_HOS{:,2:end};

%% Step 3 : loading all the test cases data into a matrix
%Loadng data

for i=1:length(VarDelta)
    for j=1:length(Var_H)
        Filepath=fullfile('/mnt','data2','saliyar','Spece_constraint','Files_from_LIGER','foamStar_2D_ParamtericStudy','Height_variation',['foamStar2D_Dx',VarDelta{i},'MeshCo',VarCo{i},'_H',Var_H{j}],'postProcessing','waveProbe','0','surfaceElevation.dat');
        Filepath_perm=fullfile('/mnt','data2','saliyar','Spece_constraint','Files_from_LIGER','foamStar_2D_ParamtericStudy',['foamStar2D_Dx',VarDelta{1},'MeshCo',VarCo{1}],'postProcessing','waveProbe','0','surfaceElevation.dat');
        data1=readtable(Filepath);
        data2=readtable(Filepath_perm);
        Eta=interp1(data1{:,1},data1{:,probe_location_cfd},data2{:,1},'spline');
        Eta_foamStar(:,n)=Eta;
         n=n+1; 
    end
end

%% Step 4: Interpolating HOS file and loading that into foamStar matrix  like 6th coloumn
Y_axis_HOS=interp1(dt_HOS,Eta_HOS(:,probe_location_HOS),data2{:,1},'spline');
Eta_foamStar(:,n)=Y_axis_HOS;

%% Obtaining Error Estimation using cross correlation between 
Time_index=find(data2{:,1}>37 & data2{:,1}<43);
%Obtaining time step from the given 
dt=data2{2,1}-data2{1,1};
Eta_foamStar_extracted_window=Eta_foamStar(Time_index,:);
dt_plot=data2{Time_index,1};
%% Plotting the Free surface of the wave probe at the centre of the domain

[nR,nC]=size(Eta_foamStar_extracted_window);
figure()

for i=1:nC
plot(dt_plot,Eta_foamStar_extracted_window(:,i),'LineWidth',2)
hold on;
ylabel('Surface elevation [m]','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)

grid on;
end
legend ('CR 1','CR 2','CR 3','CR 4','HOS','FontSize',32);
hold off;


Eta_foamStar_extracted_window=Eta_foamStar(Time_index,:);
for i=1:5
    [r(:,i),lags(:,i)]=xcorr(Eta_foamStar_extracted_window(:,i),Eta_foamStar_extracted_window(:,end),'coeff');
    [~,I(:,i)]=max(abs(r(:,i)));
    Lag(:,i)=lags(I(:,i));
    rmax(i)=max(abs(r(:,i)));
end

%% Plotting the Correlation between the Sets
figure()
for i=1

plot(rmax(i:i+4),'-o','LineWidth',3)
xlim([0.5 5.75])
xticks(1:5)
xticklabels({'CR 1','CR 2','CR 3','CR 4','HOS'})
xtickangle(45)
% xlabel('Courant Numbers','FontSize',32)
ylabel('Coefficient Correlation','FontSize',32)
set(gca,'Fontsize',32)
grid on;
hold on 
end
% legend('Dx10','Dx25','Dx50','Dx75','Dx100','FontSize',32);
hold off
