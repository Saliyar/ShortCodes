function EstimatingaddedMassforSingleCase(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To estimate the added mass for forced oscillation case %%%%%%%%%%%
%%%% Ma = \frac{c-F_a cos(phi)}{y_a w^2} -m %%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc
%% Input parameters
T_exp=4.85;
T_num=4.65;
D=0.28; % At water plane
omega_forcedoscillation=1.31; %w in rad/s
ya=0.045; % Displacement amplitude
m=339.4; % Mass in kg for particular uncertainity level
c=1000*9.81*pi/4*D^2; % rho g A_w
static_h=-2.285;


%% Estimating the Total force from openfoam

foamStarfullfile=fullfile(SPAR_Postprocessing_foamStar,'/postProcessing/forces/0/forces1.dat')
data=readtable(foamStarfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

foamStar_dtForce=data{2:end,1}; % Added the constant phase shift 

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForceX=data{2:end,2}+data{2:end,5};
foamStar_TotalForceY=data{2:end,3}+data{2:end,6};
foamStar_TotalForceZ=data{2:end,4}+data{2:end,7};

TotalForce=sqrt{foamStar_TotalForceX^2+foamStar_TotalForceY^2+foamStar_TotalForceZ^2};

%% Removing the Instantaneous Hydrostatic force 
for t=0:length(TotalForce)
   Instantaneous_HydrostaticForce=static_h+(ya *sin(omega_forcedoscillation*(t)));
end

Force=TotalForce-Instantaneous_HydrostaticForce;

%% Estimation of added mass in Time domain
AddedMass=((1/(ya*omega_forcedoscillation^2))*(c-Force))-m;


%% Estimation of damping in the Time domain


%% Plot Added mass for now!! 
plot(foamStar_dtForce,AddedMass,'LineWidth',3)
    
    %xlim([0.05 40])
    ylabel('Added Mass(kg)','interpreter','latex','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title ('Added Mass','interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    %legend (lgd8{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold off


