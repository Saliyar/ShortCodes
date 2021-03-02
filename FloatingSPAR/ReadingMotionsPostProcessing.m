%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code for visualising the motion of the floating body
%% Clearing the screen

close all
clc 
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '2'; % Choose the number stages 
parameter = 'A'; % Chose the parameters to be compared

%%Experiment  details
Exptpath=fullfile('/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/Decays/','Export4CFD_SW_SPAR_Group_M_5_heave_decay_01.mat');
% ExptIndices=355212:403205;

SPAR_Postprocessing_foamStar=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/SPAR_FreeDecay/Heave_FD/Oscillation/Heave_ppcd35_freq1');
nStart=1;
nEnd=1;
phaseshift=0;
DOF=3;

%% Mooring path
MooringPath=fullfile('/home/saliyar/MoorDyn/source/Mooring/fLine');
nStart_Line=1;
nEnd_Line=1;
NumberofSegments=6;

%% Regular wave path
foamstar2DRegularwavePath=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/RegularwaveTest/2D_Study/HOS_NWT_2DRegular/');
%% Legends
titl ={'Surge','Sway','Heave','Roll','Pitch','Yaw'}; 
titlDecay={'Heave FreeDecay','Natural period'};

ylbl={'Motion(m)','Motion(m)','Motion(m)','Motion(rad)','Motion(rad)','Motion(rad)'};
lgd1={'Freely Floating','With Stiffness Matrix'};
lgd2={'foamstar-FD','Experiment-FD'};
lgd3={'foamstar- Co 0.25','foamstar - Co 0.5','foamstar - Co 1','foamstar - Co 2','Experiment'};
lgd4={'Mass 337 kg','Mass 338.8 kg','Experiment'};
lgd5={'MOI 490','MOI 400','Experiment'};
lgd6={'ppcd 15','ppcd 25','ppcd 35','Experiment'};
lgd7={'Laminar model','fsKOmega','Experiment'};
lgd8={'All 6-DOF allowed','Only Heave allowed','Experiment'};
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
                CompareHeaveFreedecay(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd2,phaseshift)
            case 'E'
               HeaveFDCourantNumberstudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd3,phaseshift)
            case 'F'
               HeaveFD_mass_sensitivitystudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd4,phaseshift)
             case 'G'
               HeaveFD_MOI_sensitivitystudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd5,phaseshift)
            case 'H'
                EstimateNaturalPeriod_and_DampingValues(Exptpath,SPAR_Postprocessing_foamStar,titlDecay,nStart,nEnd,lgd6,phaseshift,DOF)
            case 'I'
                HeaveFD_ppcdStudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd6,phaseshift)
            case 'J'
                HeaveFD_Damping_Individualfoamstarcase(SPAR_Postprocessing_foamStar,nStart,nEnd,titlDecay,DOF)
            case 'K'
                Heave_FD_TurbulentModelstudy(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd7,phaseshift)
            case  'L'
                Heave_FD_AllmotionVsHeaveOnlymotion(Exptpath,SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd8,phaseshift)
            end
    case '2'
         switch(parameter)
            case 'A'
                VisualisingMooringlines(MooringPath,nStart_Line,nEnd_Line,NumberofSegments)  
             case 'B'
                 EstimatingaddedMassforSingleCase1(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
         end
    case '3'
         switch(parameter)
            case 'A'
                RegularWave2DProbeComparision(foamstar2DRegularwavePath)  
             case 'B'
                 EstimatingaddedMassforSingleCase1(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
            end
    otherwise
    disp('Select Properly');
end