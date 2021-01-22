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
%parameter - E for generating drag coefficient

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '1'; % Choose the number stages 
parameter = 'C' % Chose the parameters to be compared

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;



Exptpressurepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','catA_23003.mat');
ExptPressureIndices=3702:4002;
%%foamStar Test case path
foamStarfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SnappyHexMesh_TestCases/NBR_fixed_foamStar_Euler/postProcessing/';
SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SnappyHexMesh_TestCases/NBR_fixed_SWENSE_Euler_AdvMesh4/postProcessing';
SWENSEsameMeshfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SWENSE_NBR_fixed/postProcessing';

%% Number of cases for foamStar 
numfoamStar=4;
nSWENSE=4;
BaseName_foamStar='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/foamStar/foamStarTestCase';
BaseName_SWENSE='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SWENSE/SWENSETestCase';

nstart=1.2;
nend=2.5; 

lgd ={'Experiment','foamStar-BF','foamStar-SF','foamStar-SM', 'foamStar-SC','SWENSE-BF','SWENSE-SF','SWENSE-SM', 'SWENSE-SC'};      
%% Number of cases for SWENSE 
sym=1; % 1 for no symmetry ; 2 for symmetry

%Constant phase shift  between experiment and numerics
cps = 0.14; 

PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];

%Drag coefficient details
rho=1000;
D=0.22; %Diameter of the cylinder 
V=0.33; %Moving cylinder speed




%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
        
     switch(parameter)
            case 'A'
                foamStarFileName
            case 'B'
                Ncases_foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,lgd);
            case 'C'
                Ncases_foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,lgd);
            case 'D'
                foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static,Exptpressurepath,ExptPressureIndices,sym1,sym2,sym3);
            otherwise
                disp('Only between A-D');
    
            end
    
    
    case '2'
    
            switch(parameter)
            case 'A'
                foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,sym);
            case 'B'
                foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static);
            case 'C'
                foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps);
            case 'D'
                foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static,Exptpressurepath,ExptPressureIndices,sym1,sym2,sym3);
            otherwise
                disp('Only between A-D');
    
            end
    
    otherwise
    disp('Select Properly');
    
end
    
