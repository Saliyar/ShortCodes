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

%number - 1 for case comparing HOS and foamStar
%number - 2 for case comparing HOS,foamStar and SWENSE 
%parameter - A for Comparing the surfac elevation only in one case 
%parameter - B for comparing the surface elevation only in One case with diff CO
%parameter - C for comparing the surface elevation and error estimation for over all 2D Mesh and Time study
%parameter - D for comparing the surface elevation for other cases 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '2'; % Choose the number stages 
parameter = 'A' % Chose the parameters to be compared
Meshsize=0.1; %Mesh size in m
Ux=1.4; % X direction velocity from HOS 
Uy=0.5; % Z direction velocity found from openfoam
Co=1; % Only for single case 
dataNotedforTimestep=2;
%%HOS  details
HOSpath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/HOSWaveprobedetails/probes1.dat');


%%foamStar Test case path
foamStarfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/foamStar_2D_ParamtericStudy/foamStar2D_Dx100MeshCo1/postProcessing/';
SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/SWENSE_2D_ParamtericStudy/SWENSE2D_Dx100MeshCo1/postProcessing/';

 



%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
    {
        
        
    }   
        
    ExptfoamStar();
    
    case '2'
    
            switch(parameter)
            case 'A'
                foamStarSWENSEHOS_onecase(HOSpath,foamStarfile,SWENSEfile,Ux,Uy,Co,Meshsize,dataNotedforTimestep);
            case 'B'
                foamStarSWENSEHOS_onecasewithdiffCo(HOSpath,foamStarfile,SWENSEfile);
            case 'C'
                Error_parametric_study_Overall_2DCases(HOSpath,foamStarfile,SWENSEfile);
            case 'D'
                foamStarSWENSEHOS_onecase(HOSpath,foamStarfile,SWENSEfile);
            otherwise
                disp('Only between A-D');
    
            end
    
    otherwise
    disp('Select Properly');
    
end
    
