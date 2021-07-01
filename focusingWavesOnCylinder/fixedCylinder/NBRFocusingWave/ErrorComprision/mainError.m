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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%6%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input details
number = '3'; % Choose the number stages 
parameter = 'A'; % Chose the parameters to be compared
ErrorValue = 'E2'; 

%%Experiment  details
Exptforcepath=fullfile('/home/saliyar/Documents/Working/ISOPEtestcase/CategoryA/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
ExptIndices=355212:403205;

Exptpressurepath=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Experiment/Case23003/','catA_23003.mat');
ExptPressureIndices=3702:4202;

%%foamStar Test case path
foamStarfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SnappyHexMesh_TestCases/NBR_fixed_foamStar_Euler/postProcessing/';
SWENSEfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SnappyHexMesh_TestCases/NBR_fixed_SWENSE_Euler_AdvMesh/postProcessing';
SWENSEsameMeshfile='/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Fixed_NBR_focusing/SWENSE_NBR_fixed/postProcessing';
sym1=2; % 1 for no symmetry ; 2 for symmetry
sym2=2;
sym3=1;
%Constant phase shift  between experiment and numerics
cps = 0.14; 

PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];

%Drag coefficient details
rho=1000;
D=0.22; %Diameter of the cylinder 
V=0.33; %Moving cylinder speed



%% For N Number of cases
%% Number of cases for foamStar 
numfoamStar=3;
nSWENSE=4;
BaseName_foamStar='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/foamStar/foamStarTestCase';
BaseName_SWENSE='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/SWENSE/SWENSETestCase';

nstart=0.1;
nend=2.5; 

%%Computational cost
CPUTime=[38703.84 18053.67 10890 4507 54216.35 31932 24720 22062 14304];
Np=[80 80 6 6 80 80 6 1 6];
T_sim=[5 2.5 2.5 2.5 5 3 4 2.5 2.5];

ccost=(CPUTime.*Np)./T_sim;


lgd ={'foamStar-BF','foamStar-SF','foamStar-SM','foamStar-SF','SWENSE-BF','SWENSE-SF','SWENSE-SM', 'SWENSE-SC'};
mkrs=['o';'d'];                  % the desired markers lookup table
%% 

%%%%%%%%%%%%%%%%%%Main code%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch(number)
    case '1'
    switch(parameter)
            case 'A'
                switch (ErrorValue)
                    case 'E1'
                        ErrorfoamStarExpt_force_I(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,sym);
                    case 'E2'
                        ErrorfoamStarExpt_force_II(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,sym);
                    case 'E3'
                        ErrorfoamStarExpt_force_III(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,sym);
                    case 'E4'
                        ErrorfoamStarExpt_force_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,sym);
                end
                
            case 'B'
                switch (ErrorValue)
                    case 'E1'
                        ErrorfoamStarExpt_pressure_I(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost);
                    case 'E2'
                        ErrorfoamStarExpt_pressure_II(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost)
                    case 'E3'
                        ErrorfoamStarExpt_pressure_III(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,PP_static,ccost);
                    case 'E4'
                        ErrorfoamStarExpt_pressure_compAll(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,PP_static,SWENSEsameMeshfile,cps,ccost);
                end
                
                
                        
            case 'C'
                switch (ErrorValue)
                    case 'E1'
                        ErrorfoamStarExpt_surfaceElevation_I(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,ccost);
                    case 'E2'
                        ErrorfoamStarExpt_surfaceElevation_II(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,ccost);
                    case 'E3'
                        ErrorfoamStarExpt_surfaceElevation_III(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,ccost);
                    case 'E4'
                        ErrorfoamStarExpt_surfaceElevation_compAll(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,cps,ccost);
                end
                
            case 'C1'
                ErrorfoamStarExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps);
            case 'D'
                ErrorfoamStarExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static,Exptpressurepath,ExptPressureIndices,sym1,sym2,sym3);
    end
    case '2'
    
            switch(parameter)
            case 'A'
                foamStarSWENSEExpt_force(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,sym);
            case 'B'
                foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static);
            case 'C'
                foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps);
            case 'D'
                foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static,Exptpressurepath,ExptPressureIndices,sym1,sym2,sym3);
            otherwise
                disp('Only between A-D');
    
            end
    
    case '3'
    
            switch(parameter)
            case 'A'
                 switch (ErrorValue)
                    case 'E1'
                        Ncases_ErrorfoamStarExpt_surfaceElevation_I(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E2'
                        Ncases_ErrorfoamStarExpt_surfaceElevation_II(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E3'
                        Ncases_ErrorfoamStarExpt_surfaceElevation_III(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E4'
                       Ncases_ErrorfoamStarExpt_surfaceElevation_IV(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                end
            case 'B'                
                switch (ErrorValue)
                    case 'E1'
                        Ncases_ErrorfoamStarExpt_pressure_I(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E2'
                        Ncases_ErrorfoamStarExpt_pressure_II(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E3'
                        Ncases_ErrorfoamStarExpt_pressure_III(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                    case 'E4'
                        Ncases_ErrorfoamStarExpt_pressure_IV(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,ccost,lgd,mkrs);
                end
                
            case 'C'
                Error_Ncases_foamStarSWENSEExpt_surfaceElevation(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,numfoamStar,nSWENSE,nstart,nend);
            case 'D'
                Error_Ncases_foamStarSWENSEExpt_compAll(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,SWENSEsameMeshfile,cps,PP_static,Exptpressurepath,ExptPressureIndices,sym1,sym2,sym3);
            otherwise
                disp('Only between A-D');
            end
    
    otherwise
    disp('Select Properly');
    
end
    
