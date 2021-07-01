% main file
close all
clc
clear

% %% Location of Testcase root folder
RanStartTime=37;
RanEndTime=42;
numfoamStarcases=4;
numSWENSEcases=4;
numSWENSEadvantage=1;


lgd={'fsB-F','fsF2S1','fsF2S2','fsF2S3','fsF2S4','SwB-F','SwF2S1','SwF2S2',...
    'SwF2S3','SwAS1','Experiment'};


nstart=0.1;
nend=2.7;

cps=0.14; % Constant Phase shift in Experiment

%% Computational cost
% save('TimeD ata.mat','TimeData')
% load('TimeData.mat')
load('CourantTimeData.mat');
CPUTime=TimeData(:,1);
Np=TimeData(: ,2);
T_sim=TimeData(:,3);
 
ccost=(CPUTime.*Np)./T_sim;

total2Dcases=45;

%% Fixed NBR focusig  wave on cylinder  
TotalData=FixedNBR(RanStartTime,RanEndTime,numfoamStarcases,numSWENSEcases,nstart,nend,cps,lgd,ccost,numSWENSEadvantage,total2Dcases);
%TotalData.Ncases_foamStarSWENSEExpt_WaveProbes
%TotalData.Ncases_foamStarSWENSEExpt_pressure
TotalData.Ncases_foamStarSWENSEExpt_force
% TotalData.CrossCorrelationPressure
% TotalData.HOSExptWaveComp
% TotalData.foamStar2DWaveprobecomparision
% TotalData.SWENSEBottomBoundaryconditionCheck
% TotalData.SWENSE2DWaveprobecomparision
% TotalData.foamStarandSWENSE2DWaveprobecomparision
TotalData.CrossCorrelationPressureCourantNumberStudy
% TotalData.CrossCorrelationSurfaceElevationCourantNumberStudy

%% Moving NBR
% foamstarFileloc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/MovingCylinderTestcases/ParametricStudies_Nowaves/';
% numcases=3;
% Foldernames={'M112N2t0.005','M112N2t0.01','M212N2t0.005'};
% TotalData=MovingNBR(foamstarFileloc,numcases,Foldernames);
% TotalData.plotforce_comparision