function EstimatingaddedMassforSingleCase2_Gerrido(mac_SPAR_Postprocessing_foamStar,W,peakindex_start,peakindex_end,omega_forcedoscillation,za)
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
 plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
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
%% Finding the Window for Displacement time series
 
[pks,locs] = findpeaks(foamStar_TotalForceZ,'MinPeakDistance',400);
figure()
findpeaks(foamStar_TotalForceZ,'MinPeakDistance',400)




 dt1=locs(peakindex_start);
 dt2=locs(peakindex_end);
 diff_T=(locs(2)-locs(1));
 index1=(dt1);
 index2=(dt2);
 
 %% Verify the Frequency of the forced oscillation
force_time=(foamStar_dtForce(locs(2))-(foamStar_dtForce(locs(1))));
force_angularFreq=2*pi/force_time;
disp(['The input displacement freq for this case = ' num2str(omega_forcedoscillation) ' rad/s'])
disp(['The force freq for this case = ' num2str(force_angularFreq) ' rad/s'])


 dt_h=foamStar_dtForce(index1:index2);
 dt_h1=dt_h-dt_h(1);
 
foamStar_TotalForceZ_indexed=foamStar_TotalForceZ(index1:index2);
foamStar_TotalForceZ1=foamStar_TotalForceZ_indexed-mean(foamStar_TotalForceZ_indexed);
h_acc_indexed=h_acc(index1:index2);
h_vel_indexed=h_vel(index1:index2);



figure()
subplot(2,1,1)
plot(dt_h1,foamStar_TotalForceZ1,'LineWidth',3)
xlabel('Time [s]')
ylabel('Force (N)')
title('Force - Time Domain signal')
 
subplot(2,1,2)
plot(dt_h1,h_acc_indexed,'LineWidth',3)
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
title('Acceleration - Time Domain signal')

figure()
subplot(2,1,1)
plot(dt_h1,foamStar_TotalForceZ1,'LineWidth',3)
xlabel('Time [s]')
ylabel('Force (N)')
title('Force - Time Domain signal')
 
subplot(2,1,2)
plot(dt_h1,h_vel_indexed,'LineWidth',3)
xlabel('Time [s]')
ylabel('Velocity [m/s]')
title('Velocity - Time Domain signal')

%% Gerrido Method
for i=1:length(h_acc_indexed)
    Acc_Force(i)=h_acc_indexed(i)*foamStar_TotalForceZ1(i);
    Acc_square(i)=h_acc_indexed(i)*h_acc_indexed(i);
    Vel_Force(i)=h_vel_indexed(i)*foamStar_TotalForceZ1(i);
    Vel_square(i)=h_vel_indexed(i)*h_vel_indexed(i);
end
Acceleration_Numerator_Int=trapz(Acc_Force);
Acceleration_Denominator_Int=trapz(Acc_square);
Velocity_Numerator_Int=trapz(Vel_Force);
Velocity_Denominator_Int=trapz(Vel_square);

figure()
subplot(2,1,1)
plot(dt_h1,Acc_Force,'LineWidth',3)
xlabel('Time [s]')
ylabel('Accleration*Force')
title('Numerator Time Domain signal-Acceleration')
 
subplot(2,1,2)
plot(dt_h1,Acc_square,'LineWidth',3)
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
title('Denominator Time Domain signal- Acceleration')

figure()
subplot(2,1,1)
plot(dt_h1,Vel_Force,'LineWidth',3)
xlabel('Time [s]')
ylabel('Velocity*Force')
title('Numerator Time Domain signal-Velocity')
 
subplot(2,1,2)
plot(dt_h1,Vel_square,'LineWidth',3)
xlabel('Time [s]')
ylabel('Velocity [(m/s)^2]')
title('Denominator Time Domain signal- Velocity')

AddedMass=Acceleration_Numerator_Int(end)/Acceleration_Denominator_Int(end);
disp(['The added mass for this case = ' num2str(AddedMass) ' kg'])

RadiationDamping=Velocity_Numerator_Int(end)/Velocity_Denominator_Int(end);
disp(['The Radiation damping for this case = ' num2str(RadiationDamping) ' kg/s'])

