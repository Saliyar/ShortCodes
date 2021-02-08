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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '3'; % Choose the number stages 
parameter = 'A' % Chose the parameters to be compared

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details','cylinmovfnonbreak25002_1_9600Hz.MAT');
ExptIndices=187140:331140;

Exptpressurepath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details/Category_B/speed025','catB_25.mat');
ExptPressureIndices=6589:6989; %6589:6989 for 0.33 ms case 

%%foamStar Test case path
% Comparing foamStar files 
foamStarfile1='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/3D_test_drive_NBR_fine_025/postProcessing/';
foamStarfile2='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/SnappyHexMesh_Cases/MovingCylinderTestcase4/postProcessing/';

%General foamstar Test case path  
foamStarmovgenfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/SnappyHexMesh_Cases/MovingCylinderTestcase';
nStart=1;
nEnd=1;
% Change the legend as per the Story

SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/SWENSE_NBR_fixed/postProcessing/MovingCylinderTestcase';


%% Loading path for only reading moving cylinder case 
% For 0.25m/s case 
foamStar='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/MovingCylinder_CurrentOnly/MovingCylinder_case1/postProcessing/';
ExptforCheckforcePath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details','cylinmovfnonbreak25002_1_9600Hz.MAT');
ExptforCheckforcePath_Indices=187140:331140;

%For 0.75 m/s case 

foamStar='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/MovingCylinder_CurrentOnly/MovingCylinder_case2/postProcessing/';
ExptforCheckforcePath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details','cylinmovfnonbreak25002_1_9600Hz.MAT');
ExptforCheckforcePath_Indices=187140:331140;





%% Other details 
%Constant phase shift  between experiment and numerics
cps = 0.14; 

PP_static=[27.9585 18.1485 8.3385 0 0 8.3385 8.3385 8.3385];

%Drag coefficient details
rho=1000;
D=0.22; %Diameter of the cylinder 
V=0.33; %Moving cylinder speed




%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
        switch(parameter)
            case 'A'
               Expt_force(Exptforcepath,ExptIndices);
            case 'B'
                Expt_CylMovement(Exptforcepath);
            case 'C'
                foamStarMovDiffCases(Exptforcepath,ExptIndices,foamStarmovgenfile,nStart,nEnd,cps,Exptpressurepath,PP_static);
            case 'D'
               foamStarExpt_compAll(Exptforcepath,ExptIndices,foamStarfile1,foamStarfile2,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            case 'E'
                movfoamStarExpt_compPressure(foamStarfile1,foamStarfile2,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            case 'F'
                movfoamStarExpt_compSurfaceElevation(foamStarfile1,foamStarfile2,cps,Exptpressurepath,ExptPressureIndices);
            case 'G'
                movfoamStarExpt_PressureAndSurfaceElevation(foamStarfile1,foamStarfile2,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            otherwise
                disp('Only between A-E');
             end
   
    
    case '2'
    
            switch(parameter)
           case 'A'
                foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile1,SWENSEfile,cps);
%             case 'B'
%                 foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static);
%             case 'C'
%                 foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps);
%             case 'D'
%                 foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            case 'E'
                foamStarSWENSE_Cd(foamStarfile1,foamStarfile2);
            otherwise
                disp('Only between A-D');
    
            end
    case '3'
    
            switch(parameter)
           case 'A'
                foamStarExpt_force025(ExptforCheckforcePath,ExptforCheckforcePath_Indices,foamStar);
%             case 'B'
%                 foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static);
%             case 'C'
%                 foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps);
%             case 'D'
%                 foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,PP_static,Exptpressurepath,ExptPressureIndices);
            case 'E'
                foamStarSWENSE_Cd(foamStarfile1,foamStarfile2);
            otherwise
                disp('Only between A-D');
    
            end
    
    otherwise
    disp('Select Properly');
    
end
    
