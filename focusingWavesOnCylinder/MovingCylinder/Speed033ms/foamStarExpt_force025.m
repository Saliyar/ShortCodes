function foamStarExpt_force025(ExptforCheckforcePath,ExptforCheckforcePath_Indices,foamStar,PP_static)


%% Code to compare the force results between foamStar and SWENSE

%% Experimental force NBR focusing fixed cylinder - results loading
load(ExptforCheckforcePath)
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
Expt_time_cut=Expt_time(ExptforCheckforcePath_Indices,1);
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
Expt_yaxis= filtfilt(sos,g,Expt_force_N(ExptforCheckforcePath_Indices,1));

L=length(Expt_time_corrected_filtered);
Fs=1/(Expt_time_corrected_filtered(2)-Expt_time_corrected_filtered(1));
Y=fft(Expt_yaxis);
    P2=abs(Y/L);
    P1 = P2(1:L/2+1); 
    P1(2:end-1) = 2*P1(2:end-1); 
    f1 = (Fs)*(0:(L/2))/L; 


%% foamStar NBR focusing fixed cylinder force results loading

foamStarfullfile=fullfile(foamStar,'/postProcessing/forces/0/forces1.dat')
data=readtable(foamStarfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

foamStar_dtForce=data{2:end,1}; % Added the constant phase shift 

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForce=data{2:end,2}+data{2:end,5};

L=length(foamStar_dtForce);
Fs=1/(foamStar_dtForce(2)-foamStar_dtForce(1));
Y=fft(foamStar_TotalForce);
    P2=abs(Y/L);
    FP1 = P2(1:L/2+1); 
    FP1(2:end-1) = 2*FP1(2:end-1); 
    f2 = (Fs)*(0:(L/2))/L; 
    


FigH = figure('Position', get(0, 'Screensize'));
plot(foamStar_dtForce,foamStar_TotalForce,'LineWidth',3);
hold on
plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);

ylabel('Force(N)','FontSize',32,'interpreter','latex')
xlabel('Time [s]','FontSize',32,'interpreter','latex')
xlim([0.5 15])
set(gca,'Fontsize',32)
title('Totalforce X' ,'FontSize',32,'interpreter','latex')
legend ('foamStar','Experiment','FontSize',32,'interpreter','latex');
grid on;
hold off;
% saveas(FigH, ['Total Force X - MovingCylinder 0.33 m/s'],'png');

%% Plotting FFT 

FigH = figure('Position', get(0, 'Screensize'));
 plot(f2,FP1,'LineWidth',3)
 hold on
 plot(f1,P1,'LineWidth',3) 
    title('Single-Sided Amplitude Spectrum of Drag Coefficient','FontSize',32,'interpreter','latex')
    xlabel('f (Hz)','FontSize',32,'interpreter','latex')
    ylabel('|P1(f)|','FontSize',32,'interpreter','latex')
    xlim([0 0.1])
    set(gca,'Fontsize',32)
    title('Totalforce X - FFT' ,'FontSize',32,'interpreter','latex')
    legend ('foamstar','Experiment','FontSize',32,'interpreter','latex');
    grid on;
%          % legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
%          legend (lgd{:},'interpreter','latex','FontSize',32);
%    % legend(legendCell,...
%           % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
%     legend('boxon')
%     hold on
%% Plotting Pressure sensor with experiments 

% Channel 1 - Time
% Channel 2 - PP 7 
% Channel 3 - PP8 
% Channel 4 - PP 2 
% Channel 5 - PP 5
% Channel 6 - PP 3
% Channel 7 - PP 1
% Channel 8 - PP 4 
% Channel 9 - PP 6 

Expt_time=Channel_1_Data;
PP_Expt=[Channel_7_Data(:,1) Channel_4_Data(:,1) Channel_6_Data(:,1) Channel_8_Data(:,1) Channel_5_Data(:,1) Channel_9_Data(:,1) Channel_2_Data(:,1) Channel_3_Data(:,1)];

pl_timeA=Expt_time(ExptforCheckforcePath_Indices,1);

for i=1:8
    Expt_yaxis1=PP_Expt(:,i);
    yaxis= Expt_yaxis1(ExptforCheckforcePath_Indices,1);
    [Expt_yaxis1]=filterTimeSeries(yaxis);
    Expt_yaxis_filtered(:,i)= Expt_yaxis1;
end
pl_timeB=pl_timeA-pl_timeA(1); %

for i=1:8
        for kk=1:length(pl_timeB)
            Static_Pressure(kk,i)=PP_static(i);
        end
end

for j=1:8
            
      FigH = figure('Position', get(0, 'Screensize'));
     foamStarfullfile=fullfile(foamStar,'postProcessing/probes/0/p1');
     data=readtable(foamStarfullfile);
     dt_PP=data{:,1};
     PP_foamStar=data{:,j+1};
     PP1_foamStarB=(PP_foamStar)*0.01;  % Converting kg/ms2 to mbar
            
    plot(dt_PP,PP1_foamStarB,'LineWidth',3)
    hold on 
    

    plot(pl_timeB,Expt_yaxis_filtered(:,j),'LineWidth',3)
    hold on
    plot(pl_timeB,Static_Pressure(:,j),'LineWidth',3)
    xlim([2 15])
    ylabel('Dynamic Pressure [mBar]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['PP ',num2str(j)],'FontSize',32)
     legend ('foamstar','Experiment','FontSize',32,'interpreter','latex');
    grid on;
    saveas(FigH, ['PP ',num2str(i)],'png');
   % legend ('foamStar-Coarse-Euler','foamStar-Medium-Euler','Experiment','FontSize',32);
end
