function EstimatingaddedMassType3(mac_SPAR_Postprocessing_foamStar,W,peakindex_start,peakindex_end,omega_forcedoscillation,za,peakWindow)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To estimate the added mass for forced oscillation case %%%%%%%%%%%
%%%% Ma = \frac{c-F_a cos(phi)}{y_a w^2} -m %%%%%%%%%%%%%%%%%%%%%%%%


close all
clc
%% Input parameters

%% Estimating the Total force from openfoam

foamStarfullfile=fullfile(mac_SPAR_Postprocessing_foamStar,'/postProcessing/forces/0/forces1.dat')
data=readtable(foamStarfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

foamStar_dtForce=data{W:end,1}; % Added the constant phase shift 
% |t Px Py Pz Vx Vy Vz PoX Poy Poz||MPx MPy MPz MVx MVy MVz MPoX MPoy MPoz|
%Adding Pressure z component and Viscous z componenet
%Also ignoring the first term spike

foamStar_TotalForceZ=data{W:end,4}+data{W:end,7};
foamStar_TotalForceZ1=foamStar_TotalForceZ-mean(foamStar_TotalForceZ);

%% Displacement Time series

f_forced=omega_forcedoscillation/(2*pi);



     dt=foamStar_dtForce(2)-foamStar_dtForce(1);
     t=(0:dt:foamStar_dtForce(end)-dt)';
     t1=t(W:end);
     h=za *sin(2*pi*f_forced*t1);
     h_vel=omega_forcedoscillation*za*cos(2*pi*f_forced*t1);
     h_acc=-omega_forcedoscillation^2*h;
%% Plot the timeseries 
figure()
subplot(4,1,1)
 plot(foamStar_dtForce,foamStar_TotalForceZ1,'LineWidth',3)
 title('Force Z direction')
 
subplot(4,1,2)
plot(t1,h,'LineWidth',3)
title('Displacement')

subplot(4,1,3)
plot(t1,h_vel,'LineWidth',3)
title('Velocity')

subplot(4,1,4)
plot(t1,h_acc,'LineWidth',3)
title('Acceleration')
%% Solving the Algebraic Time series of Displacement, velocity and Force

for i=1:length(t1)-1
    dt(i)=t1(i);
    A=[h_acc(i) h_vel(i);h_acc(i+1) h_vel(i+1)];
    B=[foamStar_TotalForceZ1(i);foamStar_TotalForceZ1(i+1)]
    
    Sol=A\B;
    Addedmass(i)=Sol(1);
    RadiationDamping(i)=Sol(2);
    
end

figure()
plot(dt,Addedmass,'LineWidth',3)
xlabel('Time [s]')
ylabel('Added Mass (kg)')
title(['Added Mass for the case ' num2str(omega_forcedoscillation) 'rad/s'])
 

