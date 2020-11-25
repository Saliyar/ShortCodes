%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code to Compare the Parameters for fixed, SWENSE%%
% and experiment 
% Assumptions - 7 Pressure sensors and 3 wave probes only
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
parameter = 'C' % Chose the parameters to be compared

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;

Exptpressurepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','catA_23003.mat');
ExptPressureIndices=3702:4202;

%%foamStar Test case path
foamStarfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_NBR_fixedWithForce/postProcessing/';
SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/SWENSE_NBR_fixed/postProcessing/';

%Constant phase shift  between experiment and numerics
cps = 0.14; 

PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];

%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
    {
        
        
    }   
        
    ExptfoamStar();
    
    case '2'
    
            switch(parameter)
            case 'A'
                foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps);
            case 'B'
                foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static);
            case 'C'
                foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps);
            case 'D'
                foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            otherwise
                disp('Only between A-D');
    
            end
    
    otherwise
    disp('Select Properly');
    
end
    
