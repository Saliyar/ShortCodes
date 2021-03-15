function EstimatingaddedMassforSingleCase1(FileLocation,W,peakindex_start,peakindex_end,omega_forcedoscillation,za)
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
Cz=C*za;
% Force timestep starting point 


%% Estimating the Total force from openfoam

foamStarfullfile=fullfile(FileLocation,'/postProcessing/forces/0/forces1.dat')
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
     t=(0:dt:foamStar_dtForce(end))';
     t1=t(W:end);
     h=static_h+za *sin(2*pi*f_forced*t1);

     h=h-static_h;
%% Plot hte timeseries 
figure()
subplot(2,1,1)
 plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
 title('Force Z direction')
 
length(foamStar_dtForce)
length(h)
subplot(2,1,2)
plot(foamStar_dtForce,h,'LineWidth',3)
title('Displacement')
%% Finding the Window for Displacement time series
 
 [pks,locs] = findpeaks(foamStar_TotalForceZ,'MinPeakDistance',400);
% figure()
% findpeaks(foamStar_TotalForceZ)
 
force_time=(foamStar_dtForce(locs(2))-(foamStar_dtForce(locs(1))));
force_angularFreq=2*pi/force_time;
disp(['The input displacement freq for this case = ' num2str(omega_forcedoscillation) ' rad/s'])
disp(['The force freq for this case = ' num2str(force_angularFreq) ' rad/s'])



 dt1=locs(peakindex_start);
 dt2=locs(peakindex_end);
 diff_T=round(locs(2)-locs(1));
 index1=(dt1);
 index2=(dt2);

 dt_h=foamStar_dtForce(index1:index2);
 dt_h1=dt_h-dt_h(1);
 
foamStar_TotalForceZ_indexed=foamStar_TotalForceZ(index1:index2);
foamStar_TotalForceZ1=foamStar_TotalForceZ_indexed-mean(foamStar_TotalForceZ_indexed);

 
%  [pks,locs] = findpeaks(h);
%  dt1=locs(peakindex_start);dt2=locs(peakindex_end);
%  diff_T=round(locs(2)-locs(1));
%  index1=round(dt1+diff_T/4);
%  index2=round(dt2-diff_T*3/4);
%  h1=h(index1:index2);
%  dt_h=foamStar_dtForce(index1:index2);
%  dt_h1=dt_h-dt_h(1);


 %FFT of displacement  signal
  h1=h(index1:index2);
 dt_h=foamStar_dtForce(index1:index2);
 dt_h1=dt_h-dt_h(1);
Fs=1/(dt_h(2)-dt_h(1));

ff=fft(h1);
fff=ff(1:length(ff)/2);

xfft=Fs*(0:length(ff)/2-1)/length(ff);

Abs_xfft = abs(fff)/length(xfft);
[~,idxmax] = max(Abs_xfft);
Phase_max = angle(fff(idxmax));
% 
figure()
subplot(2,1,1)
plot(dt_h1,h1,'LineWidth',3)
xlabel('Time [s]')
ylabel('Displacement(m)')
title('Time Domain signal')
 
subplot(2,1,2)
plot(xfft,Abs_xfft,'LineWidth',3)
xlim([0 1])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Frequency Domain signal')




% % Substract the mean(Hydrostatic Pressure force)


%  foamStar_TotalForceZ_indexed=foamStar_TotalForceZ(index1:index2);
%  foamStar_TotalForceZ1=foamStar_TotalForceZ_indexed-mean(foamStar_TotalForceZ_indexed);
%  
%  %FFT of displacement  signal
ff=fft(foamStar_TotalForceZ1);
fff=ff(1:length(ff)/2);

xfft=Fs*(0:length(ff)/2-1)/length(ff);

Abs_xfft = abs(fff)/length(xfft);
[~,idxmax] = max(Abs_xfft);
Phase_max2 = angle(fff(idxmax));

figure()
subplot(2,1,1)
plot(dt_h1,foamStar_TotalForceZ1,'LineWidth',3)
xlabel('Time [s]')
ylabel('Force (N)')
title('Force - Time Domain signal')
 
subplot(2,1,2)
plot(xfft,Abs_xfft,'LineWidth',3)
xlim([0 1])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Frequency Domain signal')




%% %% Determining the Phase difference 
% 
t = dt_h1;
% generation of test signals with -pi/6 rad (-30 deg) phase difference
x = foamStar_TotalForceZ1;
y = h1;
% phase difference measurement
PhDiff = phdiffmeasure(x, y);
PhDiff_deg = rad2deg(PhDiff);
In_pi=PhDiff/pi;
% display the phase difference
disp(['Phase difference Y->X = ' num2str(PhDiff) ' rad, which is ' num2str(In_pi) 'of pi'])

disp(['Phase difference Y->X = ' num2str(PhDiff_deg) ' deg'])

% Phase_max-Phase_max2

%% Estimation of Added mass for this case
% Num=Cz-max(foamStar_TotalForceZ1)*cos(PhDiff);
% Num=Cz-Abs_xfft(idxmax)*cos(PhDiff);
% Denom=za*omega_forcedoscillation^2;
Num=Abs_xfft(idxmax)*cos(PhDiff)-Cz;
Denom=za*omega_forcedoscillation^2;
Added_mass=-(Num/Denom)-m;
disp(['The added mass for this case = ' num2str(Added_mass) ' kg'])

% figure()
% subplot(2,1,1)
%  plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
%  title('Force Z direction')
%  
% subplot(2,1,2)
% plot(foamStar_dtForce,h,'LineWidth',3)
% title('Displacement')