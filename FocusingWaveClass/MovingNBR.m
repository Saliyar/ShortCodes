classdef MovingNBR
    
    properties 
        fs_forcecompfileloc
        numcases
        FolderNames
        
    end
    
    
    properties(Access=private)
        ExptForce033loc
        ExptForce033Index
        ExptForce075loc
    end
    
    methods
        
        function  obj=MovingNBR(foamstarFileloc,numcases,Foldernames)
            obj.ExptForce033loc=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/MovingCylinderTestcases/Experiment/0.33ms','cylinmovfnonbreak25002_1_9600Hz.MAT');
            obj.ExptForce075loc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/MovingCylinderTestcases/Experiment/0.75ms';
            obj.ExptForce033Index=187140:331140;
            obj.fs_forcecompfileloc=foamstarFileloc;
            obj.numcases=numcases;
            obj.FolderNames=Foldernames;
            
        end
        
        function plotExptforce033(obj)
            
                load(obj.ExptForce033loc)
                Expt_time=Channel_10_Data;
                Expt_force_volts=Channel_11_Data;

                % Converting volts to N in Experimental results using calibration constant
                Expt_force_N=Expt_force_volts*2455.5; % 2455.5 N/V

                %%Indices cut from the Experiment as per the CFD simulation time
                Expt_time_cut=Expt_time(obj.ExptForce033Index,1);
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
                Expt_yaxis= filtfilt(sos,g,Expt_force_N(obj.ExptForce033Index,1));

                Expt_yaxis=fft_And_Ifft(Expt_yaxis,length(Expt_yaxis),1/(Expt_time_corrected_filtered(2)-Expt_time_corrected_filtered(1)));

                %% Plot - Uncomment if required
                figure()
                plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);
                ylabel('Force(N)','FontSize',32)
                xlabel('Time [s]','FontSize',32)
                xlim([0.5 15])
                set(gca,'Fontsize',32)
                title('Totalforce X' ,'FontSize',32)
                grid on;
            
            
        end
        
        function plotforce_anyCFDcase(obj)
            
                foamStarfullfile=fullfile(obj.fs_forcecompfileloc,'postProcessing/forces/0/forces1.dat')
                data=readtable(foamStarfullfile);
                
                foamStar_dtPP=data{100:end,1};
                foamStar_force=data{100:end,2}+data{100:end,5};
                
                    FigH = figure('Position', get(0, 'Screensize'));
            
                    plot(foamStar_dtPP,foamStar_force,'LineWidth',3);     
                    % xlim([37+obj.nstart 37+obj.nend])
                    ylabel('Force(N)','interpreter','latex','FontSize',32)
                    xlabel('Time [s]','interpreter','latex','FontSize',32)
                    set(gca,'Fontsize',32)
                    title('Force','interpreter','latex','FontSize',32)
                    grid on;
                    % grid minor;   
            
        end
        
        function plotforce_comparision(obj)
        
         load(obj.ExptForce033loc)
                Expt_time=Channel_10_Data;
                Expt_force_volts=Channel_11_Data;

                % Converting volts to N in Experimental results using calibration constant
                Expt_force_N=Expt_force_volts*2455.5; % 2455.5 N/V

                %%Indices cut from the Experiment as per the CFD simulation time
                Expt_time_cut=Expt_time(obj.ExptForce033Index,1);
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
                Expt_yaxis= filtfilt(sos,g,Expt_force_N(obj.ExptForce033Index,1));
                Expt_yaxis=fft_And_Ifft(Expt_yaxis,length(Expt_yaxis),1/(Expt_time_corrected_filtered(2)-Expt_time_corrected_filtered(1)));
                figure()
                plot(Expt_time_corrected,Expt_yaxis,'LineWidth',4);
                hold on

              % Load foamStar data 
              for k=1:obj.numcases
                foamStarfullfile0=fullfile(obj.fs_forcecompfileloc,char(obj.FolderNames(:,k)))
                foamStarfullfile=fullfile(foamStarfullfile0,'postProcessing/forces/0/forces1.dat')
                data=readtable(foamStarfullfile);
                
                foamStar_dtPP=data{100:end,1};
                foamStar_force=data{100:end,2}+data{100:end,5};
                
                plot(foamStar_dtPP,foamStar_force,'LineWidth',4); 
                hold on;
              end

                %% Plot - Uncomment if required
                
                ylabel('Force(N)','interpreter','latex','FontSize',32)
                xlabel('Time [s]','interpreter','latex','FontSize',32)
                xlim([0.5 15])
                set(gca,'FontSize',32)
                title('Totalforce X' ,'interpreter','latex','FontSize',32)
                legend(['Experiment',obj.FolderNames],'interpreter','latex','FontSize',32)
                grid on;
                grid minor;
                
        end
        
        
        
    end
    
    
end
