function EstimatingaddedMassforSingleCase2_Gerrido_Freqlessthan05Hz(mac_SPAR_Postprocessing_foamStar,W,peakindex_start,peakindex_end,omega_forcedoscillation,za)
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
foamStar_TotalForceZ=foamStar_TotalForceZ-mean(foamStar_TotalForceZ)

%% Displacement Time series

     f_forced=omega_forcedoscillation/(2*pi);
     dt=foamStar_dtForce(2)-foamStar_dtForce(1);
     t=(0:dt:foamStar_dtForce(end)-dt)';
     t1=t(W:end);
     h=za *sin(2*pi*f_forced*t1);
     h_acc=-omega_forcedoscillation^2*h;
%% Plot hte timeseries 
figure()
subplot(3,1,1)
 plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
 title('Force Z direction')
 
subplot(3,1,2)
plot(t1,h,'LineWidth',3)
title('Displacement')

subplot(3,1,3)
plot(t1,h_acc,'LineWidth',3)
title('Acceleration')

 
 %% Verify the Frequency of the forced oscillation
force_time=(foamStar_dtForce(end)-(foamStar_dtForce(1)));
force_angularFreq=2*pi/force_time;
disp(['The input displacement freq for this case = ' num2str(omega_forcedoscillation) ' rad/s'])
disp(['The force freq for this case = ' num2str(force_angularFreq) ' rad/s'])
 

%% Gerrido Method
for i=1:length(h_acc)
    Acc_Force(i)=h_acc(i)*foamStar_TotalForceZ(i);
    Acc_square(i)=h_acc(i)*h_acc(i);
end
Numerator_Int=trapz(Acc_Force);
Denominator_Int=trapz(Acc_square);

figure()
subplot(2,1,1)
plot(t1,Acc_Force,'LineWidth',3)
xlabel('Time [s]')
ylabel('Accleration*Force')
title('Numerator Time Domain signal')
 
subplot(2,1,2)
plot(t1,Acc_square,'LineWidth',3)
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
title('Denominator Time Domain signal')

Numerator_Int(end);
Denominator_Int(end);
AddedMass=Numerator_Int(end)/Denominator_Int(end);
disp(['The added mass for this case = ' num2str(AddedMass) ' kg'])


