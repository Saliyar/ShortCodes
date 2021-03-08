function EstimatingaddedMassforSingleCase2_Gerrido(mac_SPAR_Postprocessing_foamStar,W,peakindex_start,peakindex_end,omega_forcedoscillation,ya)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To estimate the added mass for forced oscillation case %%%%%%%%%%%
%%%% Ma = \frac{c-F_a cos(phi)}{y_a w^2} -m %%%%%%%%%%%%%%%%%%%%%%%%


close all
clc
%% Input parameters
rho=1000; % kg per cu.m
g=9.81;
D=0.28; % At water plane

m=339.4; % Mass in kg for particular uncertainity level
C=rho*g*pi/4*D^2; % rho g A_w
static_h=-2.285;
Cz=C*ya;
% Force timestep starting point 


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
     h=static_h+ya *sin(2*pi*f_forced*t1);

     h=h-static_h;
     h_acc=-omega_forcedoscillation^2*h;
%% Plot hte timeseries 
% figure()
% subplot(3,1,1)
%  plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
%  title('Force Z direction')
%  
% subplot(3,1,2)
% plot(t1,h,'LineWidth',3)
% title('Displacement')
% 
% subplot(3,1,3)
% plot(t1,h_acc,'LineWidth',3)
% title('Acceleration')
%% Finding the Window for Displacement time series
 
[pks,locs] = findpeaks(foamStar_TotalForceZ);
% figure()
% findpeaks(foamStar_TotalForceZ)
 
 dt1=locs(peakindex_start);
 dt2=locs(peakindex_end);
 diff_T=round(locs(2)-locs(1));
 index1=(dt1);
 index2=(dt2);

 dt_h=foamStar_dtForce(index1:index2);
 dt_h1=dt_h-dt_h(1);
 
foamStar_TotalForceZ_indexed=foamStar_TotalForceZ(index1:index2);
foamStar_TotalForceZ1=foamStar_TotalForceZ_indexed-mean(foamStar_TotalForceZ_indexed);
h_acc_indexed=h_acc(index1:index2);


% figure()
% subplot(2,1,1)
% plot(dt_h1,foamStar_TotalForceZ1,'LineWidth',3)
% xlabel('Time [s]')
% ylabel('Force (N)')
% title('Force - Time Domain signal')
%  
% subplot(2,1,2)
% plot(dt_h1,h_acc_indexed,'LineWidth',3)
% xlabel('Time [s]')
% ylabel('Acceleration [m/s^2]')
% title('Acceleration - Time Domain signal')

%% Gerrido Method
for i=1:length(h_acc_indexed)
    Acc_Force(i)=h_acc_indexed(i)*foamStar_TotalForceZ1(i);
    Acc_square(i)=h_acc_indexed(i)*h_acc_indexed(i);
end
Numerator_Int=cumtrapz(Acc_Force);
Denominator_Int=cumtrapz(Acc_square);

figure()
subplot(2,1,1)
plot(dt_h1,Acc_Force,'LineWidth',3)
xlabel('Time [s]')
ylabel('Accleration*Force')
title('Numerator Time Domain signal')
 
subplot(2,1,2)
plot(dt_h1,Acc_square,'LineWidth',3)
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
title('Denominator Time Domain signal')

Numerator_Int(end);
Denominator_Int(end);
AddedMass=Numerator_Int(end)/Denominator_Int(end);
disp(['The added mass for this case = ' num2str(AddedMass) ' kg'])


