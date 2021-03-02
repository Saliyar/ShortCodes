%% For Determining first cell widht from the cylinder estimation: 
clear
clc

%% Input 
rho=1000; % kg cu m
U=1.4; % m/s is the maximum velocity it reaches
D=0.22; % Cylinder diameter
mu=	0.000891; % Dynamic viscosity of water at 25C
yp=1;


%% Reynold number estimation
Re=rho*U*D/mu;
%% Skin friction estimation
Cf=[2*log(Re)-0.65]^(-2.3);
%% Wall shear stress 
tau=0.5*Cf*rho*U^2;
%% Frictional velocity
u=sqrt(tau/rho);
%% Compute the wall distance
%Assuming y+ value is 1; 
y=(yp*mu)/(rho*u)*1000; %Converting the y value in 'mm'
fprintf('The first cell height is %f mm',y);
