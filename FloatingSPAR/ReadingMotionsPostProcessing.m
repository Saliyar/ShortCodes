%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code for visualising the motion of the floating body
%% Clearing the screen

close all
clc 
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '4'; % Choose the number stages 
parameter = 'B'; % Chose the parameters to be compared

%%Experiment  details
Exptpath_mac=fullfile('/Users/sithikaliyar/Documents/PhD_testcases/SPAR/Experimental_Data/Decays/Experimental_Data/Decays/','Export4CFD_SW_SPAR_Group_M_5_heave_decay_01.mat');
Exptpath_office=fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/Decays','Export4CFD_SW_SPAR_ramp_steps_0_50_p_10.mat');
% ExptIndices=355212:403205;

SPAR_Postprocessing_foamStar=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/FreeDecay/HeaveFD/MeshRefinement_study/FressurfaceRefinement_Study/FreeSurfaceWidth_Study/SPAR_FS_Box');

nStart=2;
nEnd=2;
phaseshift=30.35;
DOF=3;
%% Oscillation comparision 
A=1;
office_SPAR_Postprocessing_foamStar=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/FreeDecay/Pitch_FD/Pitch_ppcd35');
mac_SPAR_Postprocessing_foamStar=fullfile('/Users/sithikaliyar/Documents/PhD_testcases/SPAR/Floating_Body_Simulation/SPAR_FreeDecay/HeaveFD/HeaveFD');
    if (A==1)
        FileLocation=office_SPAR_Postprocessing_foamStar;
        Exptpath=Exptpath_office;
    else
        FileLocation=mac_SPAR_Postprocessing_foamStar;
        Exptpath=Exptpath_mac;
    end
    
    
W=1000;
peakindex_start=2;
peakindex_end=3;
omega_forcedoscillation=1; %w in rad/s
za=0.045; % Displacement amplitude
Timestep=0.001;
peakWindow=(2*pi/omega_forcedoscillation)/Timestep;

%% Mooring path
MooringPath=fullfile('/home/saliyar/MoorDyn/source/Mooring/fLine');
nStart_Line=1;
nEnd_Line=3;
NumberofSegments=50;
%% Any random 6 DOF case 
Filelocation1=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/RegularwaveTest/Spar_regularwave1/');

%% Regular wave path
foamstar2DRegularwavePath=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/FreeDecay/Pitch_FD/Pitch_ppcd35/');
%% Legends
titl ={'Surge','Sway','Heave','Roll','Pitch','Yaw'}; 
titlDecay={'Heave FreeDecay','Natural period'};
xlbl={'t/$T_p$'};
ylbl={'Motion(m)','Motion(m)','z/$\zeta_a$','Motion(rad)','Motion(rad)','Motion(rad)'};
ylbl_deg={'Motion(m)','Motion(m)','Motion(m)','Motion(deg)','Motion(deg)','Motion(deg)'};
lgd1={'Freely Floating','With Stiffness Matrix'};
lgd2={'foamstar-FD','Experiment-FD'};
lgd3={'foamstar- Co 0.25','foamstar - Co 0.5','foamstar - Co 1','foamstar - Co 2','Experiment'};
lgd4={'Mass 337 kg','Mass 338.8 kg','Experiment'};
lgd5={'MOI 490','MOI 400','Experiment'};
lgd6={'ppcd 15','ppcd 25','ppcd 35','Experiment'};
lgd7={'Laminar model','fsKOmega','Experiment'};
lgd8={'All 6-DOF allowed','Only Heave allowed','Experiment'};

%% Irregular Wave
HOS_Filelocation=fullfile('/home/saliyar/HOS-NWT-LHEEA/bin/Results/');
ExptIrr_Filelocation= fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/OtherDatas/Irregular_Wave_Tests/Export_SW_SPAR_Group_7_irregular_waves_03.mat');
foamStar_Filelocation=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/IrregularWave/WaveOnly/LC3_2D')

%% Regular wave structure Interaction location
foamStarRegular_wavestructureInteraction=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/SPAR_ppcd35_RegularWave_testcase');
Expt_regular_path=fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/OtherDatas/Regular_Wave_Tests/','Export_SW_SPAR_Group_M4_regular_waves_01.mat');



switch(number)
    case '1'
        
     switch(parameter)
            case 'A'
                plotallmotion(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
            case 'B'
                plotSpringStiffnesscase(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd)
            case 'C'
                plotExpt_FreeDecay(Exptpath,titl,ylbl,lgd2)
            case 'D'
                CompareHeaveFreedecay(Exptpath,FileLocation,titl,ylbl,nStart,nEnd,lgd2,phaseshift)
            case 'E'
               HeaveFDCourantNumberstudy(Exptpath,FileLocation,titl,ylbl,nStart,nEnd,lgd3,phaseshift,xlbl)
            case 'F'
               HeaveFD_mass_sensitivitystudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd4,phaseshift)
             case 'G'
               HeaveFD_MOI_sensitivitystudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd5,phaseshift)
            case 'H'
                EstimateNaturalPeriod_and_DampingValues(Exptpath,FileLocation,titlDecay,nStart,nEnd,lgd6,phaseshift,DOF)
            case 'I'
                HeaveFD_ppcdStudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd6,phaseshift)
            case 'J'
                HeaveFD_Damping_Individualfoamstarcase(SPAR_Postprocessing_foamStar,nStart,nEnd,titlDecay,DOF)
            case 'K'
                Heave_FD_TurbulentModelstudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd7,phaseshift)
            case  'L'
                Heave_FD_AllmotionVsHeaveOnlymotion(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd8,phaseshift)
            case 'M'
                SPAR_OuterBoxandBottomBoxRefinment(Exptpath,FileLocation,titl,ylbl,nStart,nEnd,lgd3,phaseshift,xlbl)
            case 'N'
                SPAR_OuterBoxWidth(Exptpath,FileLocation,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
            case 'O'
                SPAR_FreeSurfaceLevel(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
            case 'P'
                SPAR_SWENSEVSfoamStar_HeaveFD(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
            case 'Q'
                SPAR_OuterBox_HeaveFD(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift,xlbl)
            case 'R'
                SPAR_FreeSurfaceWidth_HeaveFD(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
            end
    case '2'
         switch(parameter)
            case 'A'
                VisualisingMooringlines(MooringPath,nStart_Line,nEnd_Line,NumberofSegments)  
             case 'B'
                EstimatingaddedMassforSingleCase1(FileLocation,W,peakindex_start,peakindex_end,omega_forcedoscillation,za) % Displacement amplitude)
             case 'C'
                 EstimatingaddedMassforSingleCase2_Gerrido(FileLocation,W,peakindex_start,peakindex_end,omega_forcedoscillation,za,peakWindow)
             case 'D'
                 EstimatingaddedMassforSingleCase2_Gerrido_Freqlessthan05Hz(FileLocation,W,peakindex_start,peakindex_end,omega_forcedoscillation,za)
             case 'E'
                 AnsysAQWAresults(za)
             case 'F'
                 EstimatingaddedMassType3(FileLocation,W,peakindex_start,peakindex_end,omega_forcedoscillation,za,peakWindow)
                
         end
    case '3'
         switch(parameter)
            case 'A'
                 AnyWaveProbePlot(foamStar_Filelocation)  
             case 'B'
                 plotanycase_6DOFmotion(Filelocation1,titl,ylbl_deg,lgd1)
             case 'C'
                ComparePitchFreedecay(Exptpath,FileLocation,titl,ylbl,nStart,nEnd,lgd2,phaseshift,xlbl)
             case 'D'
                 CompareRegularWaveExptmotion(Expt_regular_path,foamStarRegular_wavestructureInteraction,titl,ylbl,nStart,nEnd,lgd2,phaseshift)
         end
    case '4'
        switch(parameter)
            case 'A'
                HOS_Spectrum_Within_sameFile(HOS_Filelocation)
            case 'B'
                ExptVsHOS_Spectrum_Within_sameFile(HOS_Filelocation,ExptIrr_Filelocation)
             case 'C'
                foamStarVsExptVsHOS_Spectrum_Within_sameFile(HOS_Filelocation,ExptIrr_Filelocation,foamStar_Filelocation)
        end
    otherwise
    disp('Select Properly');
end