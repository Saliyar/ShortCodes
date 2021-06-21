% main file
close all
clc
clear

%% Location of Testcase root folder
RanStartTime=37;
RanEndTime=42;
numfoamStarcases=6;
numSWENSEcases=4;

lgd={'fsB-F','fsF2S1','fsF2S2','fsF2S3','fsF2S4','fsF2S5','SwB-F','SwF2S1','SwF2S2',...
    'SwF2S3','Experiment','SwF2S4','SwF2S5','SwF1S1','SwF1S2',...
    'SwF1S3','SwF1S4'};


nstart=0.1;
nend=2.9;

cps=0.14; % Constant Phase shift in Experiment

%% Computational cost
CPUTime=[38703.84 19851 19931 12559 12197 17967 54216.35 32696 33524 23965];
Np=[80 7 7 8 10 18 80 7 7 8];
T_sim=[5 3 3 3 3 3 3 3 3 3];

ccost=(CPUTime.*Np)./T_sim;

%% Fixed NBR focusig wave on cylinder 
TotalData=FixedNBR(RanStartTime,RanEndTime,numfoamStarcases,numSWENSEcases,nstart,nend,cps,lgd,ccost);
%TotalData.Ncases_foamStarSWENSEExpt_WaveProbes
%TotalData.Ncases_foamStarSWENSEExpt_pressure
%TotalData.Ncases_foamStarSWENSEExpt_force
TotalData.CrossCorrelationPressure

%% Moving NBR
% foamstarFileloc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/MovingCylinderTestcases/ParametricStudies_Nowaves/';
% numcases=4;
% Foldernames={'M112N2t0.005','M112N2t0.01','M212N2t0.005','M213N3t0.005'};
% TotalData=MovingNBR(foamstarFileloc,numcases,Foldernames);
% TotalData.plotforce_comparision