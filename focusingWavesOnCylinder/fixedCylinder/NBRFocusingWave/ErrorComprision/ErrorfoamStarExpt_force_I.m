function ErrorfoamStarExpt_force_I(Exptforcepath,ExptIndices,foamStarfile,SWENSEfile,cps,sym)
%% Experimental force NBR focusing fixed cylinder - results loading
load(Exptforcepath)
Expt_time=Channel_10_Data;
Expt_force_volts=Channel_11_Data;

% Converting volts to N in Experimental results using calibration constant
Expt_force_N=Expt_force_volts*2455.5; % 2455.5 N/V

plot(Expt_time,Expt_force_N,'LineWidth',3);
ylabel('Force(N)','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title('Experimental Force' ,'FontSize',32)
% legend ('foamStar','Experiment','FontSize',32);
grid on;


%%Indices cut from the Experiment as per the CFD simulation time
Expt_time_cut=Expt_time(ExptIndices,1);
Expt_time_corrected=Expt_time_cut-Expt_time_cut(1,1);

%%Filtering the noises from Experimental results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Passing low pass filter over the Experimental results
Fs=9600;                                                                       % Sampling rate        
Fn=9600/2;                                                                      % Nyquist frequency
Wp =   5/Fn;                                                                    % Passband (Normalised)
Ws =  20/Fn;                                                                    % Stopband (Normalised)
Rp =  1;                                                                        % Passband Ripple
Rs = 25;                                                                        % Stopband Ripple
[n,Wn]  = buttord(Wp,Ws,Rp,Rs);                                                 % Filter Order
[b,a]   = butter(n,Wn);                                                         % Transfer Function Coefficients
[sos,g] = tf2sos(b,a);                                                          % Second-Order-Section For Stability
freqz(sos, 2048, Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Expt_time_corrected_filtered=Expt_time_corrected; 
Expt_yaxis= filtfilt(sos,g,Expt_force_N(ExptIndices,1));



%% foamStar NBR focusing fixed cylinder force results loading

foamStarfullfile=fullfile(foamStarfile,'forces/0/forces1.dat')
data=readtable(foamStarfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

foamStar_dtForce=data{2:end,1}+cps; % Added the constant phase shift 

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForce=sym*data{2:end,2}+data{2:end,5};


%% SWENSE NBR focusing fixed cylinder force results loading
SWENSEfullfile=fullfile(SWENSEfile,'forces/0/forces1.dat')
data=readtable(SWENSEfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

SWENSE_dtForce=data{2:end,1}+cps; % Added the constant phase shift given ISOPE team

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

SWENSE_TotalForce=sym*data{2:end,2}+data{2:end,5}; % Cancelling two if there is no symmetric mesh



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure()
plot(foamStar_dtForce,foamStar_TotalForce,'LineWidth',3);
hold on
plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);
hold on
plot(SWENSE_dtForce,SWENSE_TotalForce,'LineWidth',3);
ylabel('Force(N)','FontSize',32)
xlabel('Time [s]','FontSize',32)
xlim([0.5 5])
set(gca,'Fontsize',32)
title('Totalforce X' ,'FontSize',32)
legend ('foamStar','Experiment','SWENSE','FontSize',32);
grid on;

