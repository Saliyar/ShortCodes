%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code for visualising the motion of the floating body
%% Clearing the screen

close all
clc 
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '1'; % Choose the number stages 
parameter = 'C'; % Chose the parameters to be compared

%%Experiment  details
Exptpath=fullfile('/home/saliyar/Documents/PhD_testCases/FloatingSPAR/SPAR_FreeDecay/Experimental_Data/Decays/','Export4CFD_SW_SPAR_decay_yaw_01_roll.mat');
% ExptIndices=355212:403205;

SPAR_Postprocessing_foamStar=fullfile('/home/saliyar/Documents/PhD_testCases/FloatingSPAR/SPAR_Hydrostatics_R');
nStart=1;
nEnd=1;
phaseshift=6.28;


titl ={'Surge','Sway','Heave','Roll','Pitch','Yaw'}; 
ylbl={'Motion(m)','Motion(m)','Motion(m)','Motion(deg)','Motion(deg)','Motion(deg)'};
lgd1={'Freely Floating','With Stiffness Matrix'};
lgd2={'foamstar-FD','Experiment-FD'};
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
               
               

    
            end
    
    otherwise
    disp('Select Properly');
end