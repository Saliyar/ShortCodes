%% Code to check the Pressure probe results between foamStar and SWENSE
function [Expt_time_corrected,Expt_yaxis]=Expt_force(Exptforcepath,ExptIndices)

load(Exptforcepath)
Expt_time=Channel_10_Data;
Expt_force_volts=Channel_11_Data;

% Converting volts to N in Experimental results using calibration constant
Expt_force_N=Expt_force_volts*2455.5; % 2455.5 N/V

%% Plot - Uncomment if required
% plot(Expt_time,Expt_force_N,'LineWidth',3);
% ylabel('Force(N)','FontSize',32)
% xlabel('Time [s]','FontSize',32)
% set(gca,'Fontsize',32)
% title('Experimental Force' ,'FontSize',32)
% % legend ('foamStar','Experiment','FontSize',32);
% grid on;


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

Expt_yaxis=fft_And_Ifft(Expt_yaxis,length(Expt_yaxis),1/(Expt_time_corrected_filtered(2)-Expt_time_corrected_filtered(1)));

%% Plot - Uncomment if required
% figure()
% plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);
% ylabel('Force(N)','FontSize',32)
% xlabel('Time [s]','FontSize',32)
% xlim([0.5 15])
% set(gca,'Fontsize',32)
% title('Totalforce X' ,'FontSize',32)
% grid on;