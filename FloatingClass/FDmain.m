%main File

close all
clear;clc;
%% Input Selction 

dof=3;
croppingTime=1317;
Hydrostaticsloc='/home/saliyar/PhD_SithikAliyar/SPAR/foamStar_Data/Hydrostatics/Hydrostatics_W_Mooring/SRefinementL/SRefinement3';
HeaveSelection=8;

%% Loading Experimental Class - Free Decay details
ExptData=ExptFreeDecay(dof,croppingTime);
Exptxy=ExptData.croppingdata;
ExptData.mean_dof;
% 
% Loading Heave test cases of test case in foamStar

selection={'SurfaceRefinementWBox','BottomBox','NoOuterBox','OuterBoxwidth','SurfaceRefinementWoBox','foamStarPPSD35SL4', ... 
    'HydrostaticsSurfaceRefinementWBox','DifferentSchemes','TurbulenceModel','CourantNumber' };
Numberofcase=[4 4 2 2 2 1 3 4 2 3];
lgd={'Very Coarse','Coarse','Medium','Fine','Experiment'; ...
    'Very Coarse','Coarse','Medium','Fine','Experiment'; ...
    'No Outer Box', 'With Outer Box','Experiment','0','0'; ...
    'Outer Box Width 2.22D', 'Outer Box Width 1.5D','Experiment','0','0'; ...
    'Coarse Mesh', 'Fine Mesh','Experiment','0','0'; ...
    'foamStarPPSD35SL4', 'Experiment','0','0','0'; ...
    'Very Coarse','Coarse','Medium','Fine','Experiment'; ...
    'Linear Upwind','Quick','QuickV','Upwind','Experiment'; ...
    'Without Turbulence Model', 'k $\omega$ SST','Experiment','0','0'; ...
    'Co 0.25', 'Co 0.5','Co 1','Experiment','0'};
    
    
    

foamStarData=foamStarHeaveFreeDecay(Numberofcase(HeaveSelection),HeaveSelection,selection(HeaveSelection),Exptxy,lgd(HeaveSelection,:));
% foamStarData.mean_foamStar
foamStarData.plotExptVsfoamStar_singleCase


%% Loading Hydrostatics

% Hydrostatics=foamStar_Hydrostatics(Hydrostaticsloc,dof);
% Hydrostatics.mean_foamStar
% Hydrostatics.plotSingleCase

%% Comparing HOS Vs foamStar Vs Experiment 
% HOS_Filelocation=fullfile('/home/saliyar/HOS-NWT-LHEEA/bin/Results/');
% ExptIrr_Filelocation= fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/OtherDatas/Irregular_Wave_Tests/Export_SW_SPAR_Group_7_irregular_waves_03.mat');
% foamStar_Filelocation=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/IrregularWave/WaveOnly/ImprovedWIthChoiSuggestion');
% Expt_probe=1;
% % foamStarProbe2D=800; % Almost mid domain in 2D domain
% WaveprobeComparision=Waveprobe(ExptIrr_Filelocation,Expt_probe,HOS_Filelocation,foamStar_Filelocation);
% WaveprobeComparision.comparision_HOSVsfoamstar


%% RegularWave Interacion
% Expt_regular_Filelocation= fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/OtherDatas/Regular_Wave_Tests/Export_SW_SPAR_Group_EI_6_regular_wave_03.mat');
% foamStar_Filelocation=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/RegularwaveTest/2D_Study/BlockMesh2DRegularWave');
% Expt_probe=1;
% fsprobes=-17.00:0.01:17.00;
% % foamStarProbe2D=800; % Almost mid domain in 2D domain
% RegularWaveprobeComparision=RegularwavesInteraction(Expt_regular_Filelocation,Expt_probe,foamStar_Filelocation,fsprobes);
% %RegularWaveprobeComparision.comparisionVsfoamstar
% RegularWaveprobeComparision.spectrumcomparision


