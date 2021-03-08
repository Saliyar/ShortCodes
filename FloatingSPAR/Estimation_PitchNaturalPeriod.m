%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimation of Pitch Natural period %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close 
clear

rho = 1000; % kg/m^3
g=9.81; % m/s^2
submergedVolume=0.339752; %m^3
Keel=-2.285;
COB=-1.023; % Centre of Buoyancy
COG=-1.535; % Centre of Gravity 
D_wp=0.28;  % Diameter at water plane 
Iyy=490; % Mass Moment of Inertia kg m^2
AddedMass_MOI=0;


%% Estimation of GM
KB=abs(Keel-COB);
KG=abs(Keel-COG);
I_wp=(pi/64)*D_wp^4;
BM=I_wp/submergedVolume;
GM=KB+BM-KG;

%% Restoring Moment
CM=rho*g*submergedVolume*GM;

%% Estimation of Pitch/Roll Natural period
T=2*pi*sqrt((Iyy+AddedMass_MOI)/CM);
fprintf('Theoratical Natural period is %f (s) \n',T);
