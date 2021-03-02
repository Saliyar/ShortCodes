function EstimatingaddedMassforSingleCase(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% To estimate the added mass for forced oscillation case %%%%%%%%%%%
%%%% Ma = \frac{c-F_a cos(phi)}{y_a w^2} -m %%%%%%%%%%%%%%%%%%%%%%%%


close all
clc
%% Ansys AQWA results 
omega_AQWA=[0.35 0.5 0.65 0.8 0.955 1.1 1.25];
AddedMass_AQWA=[30.15 30.30 28.75 27.04 26.011 25.58543 25.58755];
FigH = figure('Position', get(0, 'Screensize'));
plot(omega_AQWA,AddedMass_AQWA,'LineWidth',3)
    ylabel('Added Mass(kg)','FontSize',32)
    xlabel('\omega (rad/s)','FontSize',32)
    set(gca,'Fontsize',32)
    xlim([0.25 1.5]);
    title ('ANSYS AQWA - Added mass Vs Frequency','interpreter','latex','FontSize',32);
    % legend (lgd6{:},'interpreter','latex','FontSize',32,'Location','northeast');
    grid on;

%% Input parameters
rho=1000; % kg per cu.m
g=9.81;
T_exp=4.85;
T_num=4.65;
D=0.28; % At water plane
omega_forcedoscillation=1.31; %w in rad/s
ya=-0.045; % Displacement amplitude
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

% |t Px Py Pz Vx Vy Vz PoX Poy Poz||MPx MPy MPz MVx MVy MVz MPoX MPoy MPoz|
%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForceX=data{2:end,2}+data{2:end,5};
foamStar_TotalForceY=data{2:end,3}+data{2:end,6};
foamStar_TotalForceZ=data{2:end,4}+data{2:end,7};

foamStar_TotalMomentX=data{2:end,11}+data{2:end,14};
foamStar_TotalMomentY=data{2:end,12}+data{2:end,15};
foamStar_TotalMomentZ=data{2:end,13}+data{2:end,16};


foamStar_TotalForceZ=foamStar_TotalForceZ-mean(foamStar_TotalForceZ);

% Y = fft(foamStar_TotalForceZ);
% 
fs = 1/(foamStar_dtForce(2)-foamStar_dtForce(1));            % Sampling frequency                    
Ts = 1/fs;             % Sampling period      
L = length(foamStar_dtForce);
T = (0:L-1)*Ts;
freq = 0:L-1;
freq = freq*fs/L;
cutOff = L/2;
freq = freq(1:cutOff);
X = fft(foamStar_TotalForceZ);
Xabs = abs(X);
X = X(1:cutOff);

%    FigH = figure('Position', get(0, 'Screensize'));
%    subplot(5,1,1)
%    plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
%    % Add title and axis labels
%     title('Time series')
%     xlim([0 15])
%    subplot(5,1,2)
%     plot(Xabs,'LineWidth',3)
%     title('Frequencies in the signal')
%     xlim([0 50])
%    subplot(5,1,3)
%    absXnorm = 2*abs(X)/L;
%    plot(freq, absXnorm,'LineWidth',3)
%     title('Module of fft')
%     xlim([0 2])
%    subplot(5,1,4)
%    plot(freq, real(X),'LineWidth',3);
%    title('Real part')
%     xlim([0 2])
%    subplot(5,1,5)
%    plot(freq, imag(X),'LineWidth',3);
%    
%     title('Imaginary part')
%     xlim([0 2])

% plot(y)

% TotalForce=sqrt(foamStar_TotalForceX.^2+foamStar_TotalForceY.^2+foamStar_TotalForceZ.^2);

% plot(foamStar_dtForce,TotalForce,'LineWidth',3)
%     
%     xlim([0.05 40])
%     ylabel('Added Mass(kg)','interpreter','latex','FontSize',32)
%     xlabel('Time [s]','FontSize',32)
%     set(gca,'Fontsize',32)
%     title ('Added Mass','interpreter','latex','FontSize',32);
%     legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
%     legend (lgd8{:},'interpreter','latex','FontSize',32,'Location','southwest');
%     grid on;
%     hold off
    

%% Removing the Instantaneous Hydrostatic force
for i=1:length(foamStar_dtForce)
%     
     h(i)=static_h+ya *sin(omega_forcedoscillation*(foamStar_dtForce(i)));
     
%      Instantaneous_HydrostaticForce(i)=rho*g*D*h(i)^2;
%      Force(i)=foamStar_TotalForceZ(i)-Instantaneous_HydrostaticForce(i);
end
h=h-mean(h);
 X1 = fft(h);
Xabs1 = abs(X1);
X1 = X1(1:cutOff);

% %% FFT of force to obtain the amplitude
% L=length(TotalForce);
% Fs=1/(foamStar_dtForce(2)-foamStar_dtForce(1));
% Y=fft(Force);
%     P2=abs(Y/L);
%     P1 = P2(1:L/2+1); 
%     P1(2:end-1) = 2*P1(2:end-1); 
%     f1 = (Fs)*(0:(L/2))/L; 
% 
% plot(f1,P1)
% 
% %% Estimation of added mass in Time domain
% Denom=ya*omega_forcedoscillation^2;
% AddedMass=(1/(Denom))*(c-max(P1))-m


%% lotting Force and Displacement function 
   FigH = figure('Position', get(0, 'Screensize'));
   subplot(2,1,1)
    plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
    title('Force signal Time series')
    subplot(2,1,2)
    plot(foamStar_dtForce,h,'LineWidth',3)
    title('Displacemenet Time series')
%    
    FigH = figure('Position', get(0, 'Screensize'));
    subplot(2,1,1)
    absXnorm = 2*abs(X)/L;
    plot(freq, absXnorm,'LineWidth',3)
    title('Force Frequencies in the signal')
    xlim([0 5])
   subplot(2,1,2)
     absXnorm1 = 2*abs(X1)/L;
    plot(freq, absXnorm1,'LineWidth',3)
    title('Displacement Frequencies in the signal')
    xlim([0 5])
%     
 %% Determining the Phase difference 
%  figure()
% t = foamStar_dtForce;
% % generation of test signals with -pi/6 rad (-30 deg) phase difference
% y = foamStar_TotalForceZ;
% x = h;
% % phase difference measurement
% PhDiff = phdiffmeasure(x, y);
% PhDiff = rad2deg(PhDiff);
% % display the phase difference
% disp(['Phase difference Y->X = ' num2str(PhDiff) ' deg'])
% commandwindow
% % plot the signals
% figure(1)
% plot(t, x, 'b', 'LineWidth', 1.5)
% grid on
% hold on
% plot(t, y, 'r', 'LineWidth', 1.5)
% %xlim([0 T])
% %ylim([-1.5 1.5])
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlabel('Time, s')
% ylabel('Amplitude, V')
% title('Two signals with phase difference')
% legend('First signal X', 'Second signal Y')


%% Plot Added mass for now!! 
% %  FigH = figure('Position', get(0, 'Screensize'));
%    plot(foamStar_dtForce,foamStar_TotalForceZ,'LineWidth',3)
% % 
% %     
%     %xlim([0.05 40])
%     ylabel('Draft variation(m)','interpreter','latex','FontSize',32)
%     xlabel('Time [s]','FontSize',32)
%     set(gca,'Fontsize',32)
%     title ('Displacement','interpreter','latex','FontSize',32);
%     % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
%     %legend (lgd8{:},'interpreter','latex','FontSize',32,'Location','southwest');
%     grid on;
%     hold off
% saveas(FigH, 'Displacement','png');

%% 2: Take the FFT of each of the two signals
signal_1_fft = fft(foamStar_TotalForceZ);
signal_2_fft = fft(h);

% Throw away DC component that should be at index 0 in a sane language
signal_1_fft = signal_1_fft(2:end);
signal_2_fft = signal_2_fft(2:end);


%% 3: Find the phases of each signal

signal_1_phase = unwrap(angle(signal_1_fft));
signal_2_phase = unwrap(angle(signal_2_fft));


%% 4: Now we can find the phase angle difference between the two signals
signal_phase_diff = signal_2_phase - signal_1_phase;


%% 5: Next we can pull out the phase diff at the frequency of interest:

% Convert from bin number to frequency from 0 to Fs
binNum = ((length(signal_1_fft))/fs)*freq;
binNum = round(binNum);

phase_diff = signal_phase_diff(binNum);



%% Display result in degrees
sprintf('Phase difference between signals at %d Hz is %f degrees', freq, (phase_diff*180)/pi)

