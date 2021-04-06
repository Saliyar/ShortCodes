%% Pressure and surface elevation comparision between Presssure input given from sriram et al and spread sheet saved from Paraview
%% Pressure probes to check is 8
clear all;
close all;
clc


user = 'ben';
switch user
    case 'ben'
        path_main = 'D:\ownCloudData\Shared\Doubt_now\';
    case 'sithik'
        path_main = 'D:\ownCloudData\Shared\Doubt_now\';
end
path_exp=[path_main 'Experimental Results\'];
path_num=[path_main 'SWENSE results\'];

%%% Load Exp
[time_Sriram,PP_Sriram] =loadExpDataSriram([path_exp 'catA_23003.mat']);
figure(1)
plot(time_Sriram, PP_Sriram(:,:))


%%% Batch 1
num_case = {'Co_0.2','Co_0.15','Co_0.1'};
Convlist = [0.2 0.15 0.1];

info.tbeg_err =37.5;
info.tend_err =40;

%%% Batch 2
num_case = {'Co_0.2','Co_0.15','Co_0.1'};
Convlist = [0.2 0.15 0.1];

info.tbeg_err =39;
info.tend_err =39.5;

%%% Batch Dx 1
num_case = {'Mesh1_Co0.2','Mesh2_Co0.2','Mesh3_Co0.2'};
Convlist = [0.2 0.15 0.1];

info.tbeg_err =37.5;
info.tend_err =40;



for iCase = 1:length(num_case)
    
    Err{iCase} = AnalyseSingleRun(path_num,num_case{iCase},time_Sriram,PP_Sriram, info);
    
end

%%%% See evolution of errors

for iProbe =2:8
    for iCase = 1:length(num_case)
        RelAreaNorm2(iCase) = Err{iCase}(iProbe).RelAreaNorm2;
        RelMax(iCase) = Err{iCase}(iProbe).RelMax;
    end
    
    figure(200+ iProbe)
    plot(Convlist, RelAreaNorm2)
    
    figure(300+ iProbe)
    plot(Convlist, RelMax)
    
end