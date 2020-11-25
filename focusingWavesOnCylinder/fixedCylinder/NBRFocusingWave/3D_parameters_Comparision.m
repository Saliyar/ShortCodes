%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to Compare the Parameters for fixed, SWENSE%%
% and experiment 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clearing the screen 
close all
clc 
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number - 1 for case comparing Experiment and foamStar
%number - 2 for case comparing Experiment,foamStar and SWENSE 
%parameter - A for Comparing the forces only 
%parameter - B for comparing the pressure only
%parameter - C for comparing the surface elevation only 
%parameter - D for comparing everything together 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '2'; % Choose the number stages 
parameter = 'D' % Chose the parameters to be compared
%%Force details
Exptforcepath=fullfile(/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/,'cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;

%%foamStar Test case path
foamStarfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_NBR_fixedWithForce/postProcessing/';
SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_NBR_fixedWithForce/postProcessing/';

%Constant phase shift  between experiment and numerics
cps = 0.14; 
switch(number)
    case '1'
    {
        switch(parameter)
        case 
        
    }   
        
    ExptfoamStar();
    
    case '2'
    {
            switch(parameter)
            case 'A'
                foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps);
            case 'B'
                foamStarSWENSEExpt_pressure();
            case 'C'
                foamStarSWENSEExpt_surfaceElevation();
            case 'D'
                foamStarSWENSEExpt_compAll();
            otherwise
                disp('Only between A-D');
    }
            
    
    otherwise
    disp('Select Properly');
    
end
    
