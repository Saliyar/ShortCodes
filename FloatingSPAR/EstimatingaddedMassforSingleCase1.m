function EstimatingaddedMassforSingleCase1(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To estimate the added mass for forced oscillation case %%%%%%%%%%%
%%%% Ma = \frac{c-F_a cos(phi)}{y_a w^2} -m %%%%%%%%%%%%%%%%%%%%%%%%


close all
clc
%% Input parameters
rho=1000; % kg per cu.m
g=9.81;
D=0.28; % At water plane
omega_forcedoscillation=1.3; %w in rad/s
ya=-0.045; % Displacement amplitude
m=339.4; % Mass in kg for particular uncertainity level
C=rho*g*pi/4*D^2; % rho g A_w
static_h=-2.285;
Cz=C*ya;
% Force timestep starting point 
W=10;
peakindex_start=1;
peakindex_end=8;

%% Estimating the Total force from openfoam

foamStarfullfile=fullfile(SPAR_Postprocessing_foamStar,'/postProcessing/forces/0/forces1.dat')
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
%% Finding the Window for Displacement time series
 
 [pks,locs] = findpeaks(h);
 dt1=locs(peakindex_start);dt2=locs(peakindex_end);
 diff_T=round(locs(4)-locs(3));
 index1=round(dt1+diff_T/4);
 index2=round(dt2-diff_T*3/4);
 h1=h(index1:index2);
 dt_h=foamStar_dtForce(index1:index2);
 dt_h1=dt_h-dt_h(1);


 %FFT of displacement  signal
Fs=1/(dt_h(2)-dt_h(1));

ff=fft(h1);
fff=ff(1:length(ff)/2);

xfft=Fs*(0:length(ff)/2-1)/length(ff);

Abs_xfft = abs(fff)/length(xfft);
% 
% figure()
% subplot(2,1,1)
% plot(dt_h1,h1,'LineWidth',3)
% xlabel('Time [s]')
% ylabel('Displacement(m)')
% title('Time Domain signal')
%  
% subplot(2,1,2)
% plot(xfft,Abs_xfft,'LineWidth',3)
% xlim([0 1])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% title('Frequency Domain signal')




% % Substract the mean(Hydrostatic Pressure force)


 foamStar_TotalForceZ_indexed=foamStar_TotalForceZ(index1:index2);
 foamStar_TotalForceZ1=foamStar_TotalForceZ_indexed-mean(foamStar_TotalForceZ_indexed);
 
 %FFT of displacement  signal
ff=fft(foamStar_TotalForceZ1);
fff=ff(1:length(ff)/2);

xfft=Fs*(0:length(ff)/2-1)/length(ff);

Abs_xfft = abs(fff)/length(xfft);

% figure()
% subplot(2,1,1)
% plot(dt_h1,foamStar_TotalForceZ1,'LineWidth',3)
% xlabel('Time [s]')
% ylabel('Force (N)')
% title('Force - Time Domain signal')
%  
% subplot(2,1,2)
% plot(xfft,Abs_xfft,'LineWidth',3)
% xlim([0 1])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude')
% title('Frequency Domain signal')




%% %% Determining the Phase difference 
% 
t = dt_h1;
% generation of test signals with -pi/6 rad (-30 deg) phase difference
x = foamStar_TotalForceZ1;
y = h1;
% phase difference measurement
PhDiff = phdiffmeasure(x, y);
% PhDiff = rad2deg(PhDiff);
% display the phase difference
disp(['Phase difference Y->X = ' num2str(PhDiff) ' rad'])

%% Estimation of Added mass for this case
Num=Cz-max(foamStar_TotalForceZ1)*cos(PhDiff);
Denom=ya*omega_forcedoscillation^2;
Added_mass=(Num/Denom)-m;
disp(['The added mass for this case = ' num2str(Added_mass) ' kg'])

% figure()
% subplot(2,1,1)
%  plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
%  title('Force Z direction')
%  
% subplot(2,1,2)
% plot(foamStar_dtForce,h,'LineWidth',3)
% title('Displacement')