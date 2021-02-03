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
number = '1'; % Choose the number stages 
parameter = 'A' % Chose the parameters to be compared

%%Experiment  details
%%Exptforcepath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details','cylinmovfnonbreak25002_1_9600Hz.MAT');
%% ExptIndices=187140:331140;

%% Exptpressurepath=fullfile('/home/saliyar/PhD_SithikAliyar/Cylinder_NonBreaking_focussingwave/Moving_cylinder/Wave_generation_Experiement_details/Category_B/speed075','catB_75.mat');
%% ExptPressureIndices=5909:6303; %6589:6989 for 0.33 ms case 
%% load(Exptpressurepath)

%%foamStar Test case path
% Comparing foamStar files 
foamStarfile1='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/3D_test_drive_NBR_fine075/postProcessing/';
%% foamStarfile2='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/SnappyHexMesh_Cases/MovingCylinderTestcase5/postProcessing/';

%General foamstar Test case path  
foamStarmovgenfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Moving_test_cases/3D_CircularCylinder/Re55000/LaminarModel/CourantNumber_Study/3DCylinderCase';
nStart=1;
nEnd=4;
% Change the legend as per the Story
% lgd ={'Coarse Mesh (cell size-1D )','Medium Mesh (cell size- 0.5D)','FineMesh (cell size -0.25D)'};
% lgd={'linear','linearUpwindV', 'QuickV', 'upwind', 'vanLeerV'};
lgd={'Co 1','Co 0.5','Co 0.25', 'Co 0.1'};
nCases=nStart:nEnd
%% SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/SWENSE_NBR_fixed/postProcessing/MovingCylinderTestcase';

%Constant phase shift  between experiment and numerics
%% cps = 0.14; 

%% PP_static=[27.9585 18.1485 8.3385 0 0 8.3385 8.3385 8.3385];

%Drag coefficient details
%%rho=1000;
D=0.22; %Diameter of the cylinder 
U=1; %Moving cylinder speed




%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
        switch(parameter)
            case 'A'
               ReadCoefficients(foamStarmovgenfile,nStart,nEnd,D,U,lgd,nCases);
            otherwise
                disp('Only between A-E');
             end
   
    
    case '2'
    
            switch(parameter)
%             case 'A'
%                 foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps);
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
    
