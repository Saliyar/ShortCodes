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
parameter = 'A' % Chose the parameters to be compared

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;

SPAR_Postprocessing_foamStar=fullfile('/home/saliyar/Documents/PhD_testCases/FloatingSPAR/SPAR_Justfloating/postProcessing/');



switch(number)
    case '1'
        
     switch(parameter)
            case 'A'
                plotallmotion(SPAR_Postprocessing_foamStar)
               
               

    
            end
    
    otherwise
    disp('Select Properly');
end