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
parameter = 'A'; % Chose the parameters to be compared

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;

SPAR_Postprocessing_foamStar=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/SPAR_Hydrostatics_R');
nStart=2;
nEnd=2;
titl ={'Surge','Sway','Heave','Roll','Pitch','Yaw'}; 
ylbl={'Motion(m)','Motion(m)','Motion(m)','Motion(deg)','Motion(deg)','Motion(deg)'};

switch(number)
    case '1'
        
     switch(parameter)
            case 'A'
                plotallmotion(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd)
               
               

    
            end
    
    otherwise
    disp('Select Properly');
end