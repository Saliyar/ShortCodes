classdef FixedNBR
    
    properties 
        RanStartTime
        RanEndTime
        numcases
        nstart
        nend
        cps
        Exptforcepath
        ExptforceIndices
        foamStarnumcases
        SWENSEnumcases
        lgd
        ccost      
    end
    
    properties (Access=private)
        Exptlocation
        ExptIndices
        foamStarSWENSE_rootFolder
        foamStarTestcases
        PP_static
        FolderDestination
        
    end
    
    properties (Dependent)
        
    end
    
    methods
      
        % Constructor 
        function obj=FixedNBR(RanStartTime,RanEndTime,numfoamStarcases,numSWENSEcases,nstart,nend,cps,lgd,ccost)
            
          obj.Exptlocation=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Experiment/Case23003/','catA_23003.mat');
          obj.ExptIndices=RanStartTime*100+2:RanEndTime*100+2; % Based on earlier study
          obj.foamStarSWENSE_rootFolder=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder');
          obj.foamStarnumcases=numfoamStarcases;
          obj.SWENSEnumcases=numSWENSEcases;
          obj.numcases=numfoamStarcases+numSWENSEcases;
          obj.nstart=nstart;
          obj.nend=nend;
          obj.PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];
          obj.cps=cps;  
          obj.FolderDestination='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Graphs';
          obj.Exptforcepath=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Experiment/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
          obj.ExptforceIndices=355212:403205;
          obj.lgd=lgd;
          obj.ccost=ccost;
        end
        
        % Other public functions
        
        function  ExperimentPressurePlot(obj)
            
            % Code to check the Pressure probe results between foamStar and SWENSE
            %% Experimental results loading

            load(obj.Exptlocation)

            PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];
            
            
            
            

            %Selection time 5s to 35s overall. with constant phase shift is reduced

            pl_time=pp2(obj.ExptPressureIndices,1);   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            for i=1:8
                figure()
                plot(pl_time,PP_Expt(obj.ExptIndices,i),'LineWidth',3)
               %   xlim([0.05 2.5])
                ylabel('Dynamic Pressure [mBar]','interpreter','latex','FontSize',32)
                xlabel('Time [s]','interpreter','latex','FontSize',32)
                set(gca,'Fontsize',32)
                title(['PP ',num2str(i)],'interpreter','latex','FontSize',32)
                grid on;
                grid minor;
                
            end

%            
        
        end
        
        function  Ncases_foamStarSWENSEExpt_pressure(obj)
            
            % Code to check the Pressure probe results between foamStar and SWENSE
            %% Experimental results loading

            load(obj.Exptlocation)

            PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

            pl_time=pp2(obj.ExptIndices,1);   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/foamStarTestCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/SWENSETestCase');
            Basename=[foamStar_Basename SWENSE_Basename]
            for k=1:obj.numcases
                FileName=[foamStar_Basename,num2str(k)];
                
                if (k>obj.foamStarnumcases)
                   
                    FileName=[SWENSE_Basename,num2str(k-obj.foamStarnumcases)];
                    
                end
                    
                
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
                data=readtable(foamStarfullfile);
                
                %Finding Indexes
                start_idx=find(data{:,1}==obj.nstart);
                end_idx=find(data{:,1}==obj.nend);
                
                foamStar_dtPP(:,k)=data{start_idx:end_idx,1}+37; % 37 is the starting time in all cases(Hope so)
                PP_foamStar=data{start_idx:end_idx,2:end};
                
                for pp=2:8
                    foamStar_PP(:,pp,k) = PP_foamStar(:,pp)*0.01-obj.PP_static(pp);
                    
                end
                clear FileName data start_idx end_idx PP_foamStar 
            end
           
            
            
            
            %% Plot 
          for i=2:8
            
              FigH = figure('Position', get(0, 'Screensize'));
              
            for k=1:obj.numcases
            
            plot(foamStar_dtPP(:,k),foamStar_PP(:,i,k),'LineWidth',3);     
            hold on ;                
            end
            plot(pl_time-obj.cps,PP_Expt(obj.ExptIndices,i),'--','Color','k','LineWidth',3) % Costant phase shift is substracted
            xlim([37+obj.nstart 37+obj.nend])
            ylabel('Dynamic Pressure [mBar]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title(['PP ',num2str(i)],'interpreter','latex','FontSize',32)
            grid on;
            % grid minor;
            
            legend(obj.lgd{:},'interpreter','latex','Location','northwest','NumColumns',2)
          
            % legend('fsB-F','fsS-VC','fsS-C','fsS-M','fsS-F','fsS-VF','Experiment','SwB-F','SwS-F','SwS-M','SwS-C','SwS-RL4','Experiment','interpreter','latex','Location','northwest','NumColumns',2)
            SavingFile=fullfile(obj.FolderDestination,['PP',num2str(i)]);
            saveas(FigH, SavingFile,'epsc');
              
         end
            
        end
        
          function  Ncases_foamStarSWENSEExpt_WaveProbes(obj)
            
            % Code to check the Pressure probe results between foamStar and SWENSE
            %% Experimental results loading

            load(obj.Exptlocation)

            WP_Expt=[wp5(:,2) wp6(:,2) wp7(:,2)];

            pl_time=wp5(obj.ExptIndices,1);   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/foamStarTestCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/SWENSETestCase');
            Basename=[foamStar_Basename SWENSE_Basename];
            
             for k=1:obj.numcases
            
                    FileName=[foamStar_Basename,num2str(k)];
                
                if (k>obj.foamStarnumcases)
                   
                    FileName=[SWENSE_Basename,num2str(k-obj.foamStarnumcases)];
                    
                end
                    
                
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
                data=readtable(foamStarfullfile);
                
                %Finding Indexes
                start_idx=find(data{:,1}==obj.nstart);
                end_idx=find(data{:,1}==obj.nend);
                
                foamStar_dtPP(:,k)=data{start_idx:end_idx,1}+37; % 37 is the starting time in all cases(Hope so)
                PP_foamStar=data{start_idx:end_idx,2:end};
                
                for pp=1:3
                    foamStar_PP(:,pp,k) = PP_foamStar(:,pp);
                    
                end
                clear FileName data start_idx end_idx PP_foamStar  
             end
            
            %% Plot 
          for i=1:3
            
              FigH = figure('Position', get(0, 'Screensize'));
              
            for k=1:obj.numcases
            
            plot(foamStar_dtPP(:,k),foamStar_PP(:,i,k),'LineWidth',3);     
            hold on ;                
            end
            plot(pl_time-obj.cps,WP_Expt(obj.ExptIndices,i),'--','Color','k','LineWidth',3) % Costant phase shift is substracted
            xlim([37+obj.nstart 37+obj.nend])
            ylabel('Dynamic Pressure [mBar]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title(['WP ',num2str(i+4)],'interpreter','latex','FontSize',32)
            grid on;
            % grid minor;
            
            legend('fsB-F','fsS-VC','fsS-C','fsS-M','fsS-F','fsS-VF','Experiment','SwB-F','SwS-F','SwS-M','SwS-C','SwS-RL4','Experiment','interpreter','latex','Location','northwest','NumColumns',2)
            SavingFile=fullfile(obj.FolderDestination,['WP',num2str(i+4)]);
            saveas(FigH, SavingFile,'epsc');
              
         end
            
          end
        
          
            function  Ncases_foamStarSWENSEExpt_force(obj)
            
            % Code to check the Pressure probe results between foamStar and SWENSE
            %% Experimental results loading

            load(obj.Exptforcepath)
            
            Expt_start=355212;
            Expt_end=403205;
            Expt_time=Channel_10_Data(Expt_start:Expt_end)-Channel_10_Data(1);
            % Expt_time=Channel_10_Data  
           
             Expt_force_N=Channel_11_Data(Expt_start:Expt_end)*2455.5;% Converting volts to N in Experimental results using calibration constant
            % Expt_force_N=Channel_11_Data*2455.5;% Converting volts to N in Experimental results using calibration constant
            
            figure()
            plot(Expt_time,Expt_force_N)
            
            clear Channel*
            
            %%Filtering the noises from Experimental results
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Passing low pass filter over the Experimental results
            figure()
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
            Expt_yaxis= filtfilt(sos,g,Expt_force_N(:,1));

            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/foamStarTestCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/SWENSETestCase');
            Basename=[foamStar_Basename SWENSE_Basename]
            for k=1:obj.numcases
                FileName=[foamStar_Basename,num2str(k)];
                                
                if (k>=5)
                   
                    FileName=[SWENSE_Basename,num2str(k-4)];
                    
                end
                    
                
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/forces/0/forces1.dat')
                data=readtable(foamStarfullfile);
                
                %Finding Indexes
                start_idx=find(data{:,1}==obj.nstart);
                end_idx=find(data{:,1}==obj.nend);
                
                foamStar_dtPP(:,k)=data{start_idx:end_idx,1}+37; % 37 is the starting time in all cases(Hope so)
                
                if (k==1 || k==5)
                    
                    sym=2;
                else 
                    
                    sym=1;
                    
                end
                
                
                
                PP_foamStar=sym*(data{start_idx:end_idx,2} + data{start_idx:end_idx,5});
                
                foamStar_PP(:,1,k) = PP_foamStar(:,1);
                    
                clear FileName data start_idx end_idx PP_foamStar 
            end
           
            
            
            
            %% Plot
            close all
              FigH = figure('Position', get(0, 'Screensize'));
              
            for k=1:obj.numcases
            
            plot(foamStar_dtPP(:,k),foamStar_PP(:,1,k),'LineWidth',3);     
            hold on ;                
            end
            plot(Expt_time-obj.cps,Expt_yaxis,'--','Color','k','LineWidth',3) % Costant phase shift is substracted
            xlim([37+obj.nstart 37+obj.nend])
            ylabel('Dynamic Pressure [mBar]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title('Force','interpreter','latex','FontSize',32)
            grid on;
            % grid minor;
            
            legend('fsB-F','fsS-VC','fsS-C','fsS-M','fsS-F','fsS-VF','Experiment','SwB-F','SwS-F','SwS-M','SwS-C','SwS-RL4','Experiment','interpreter','latex','Location','northwest','NumColumns',2)
            SavingFile=fullfile(obj.FolderDestination,'Force');
            saveas(FigH, SavingFile,'epsc');
              
            
            end
            
            function CrossCorrelationPressure(obj)
            
                % Loading Experimental data
            load(obj.Exptlocation)

            PP_Expt=[pp2(obj.ExptIndices,2) pp2(obj.ExptIndices,2) pp3(obj.ExptIndices,2) pp4(obj.ExptIndices,2) pp5(obj.ExptIndices,2) pp6(obj.ExptIndices,2) pp7(obj.ExptIndices,2) pp8(obj.ExptIndices,2)];

            pl_time=pp2(obj.ExptIndices,1)-obj.cps;   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/foamStarTestCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/SWENSETestCase');
            Basename=[foamStar_Basename SWENSE_Basename]
            for k=1:obj.numcases
                FileName=[foamStar_Basename,num2str(k)];
                
                if (k>obj.foamStarnumcases)
                   
                    FileName=[SWENSE_Basename,num2str(k-obj.foamStarnumcases)];
                    
                end
                    
                
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
                data=readtable(foamStarfullfile);
                
                %Finding Indexes
                start_idx=find(data{:,1}==obj.nstart);
                end_idx=find(data{:,1}==obj.nend);
                % foamStarPP_interp=interp1(foamStar_dtPP(:,k),foamStar_PP(:,i,k),foamStar_dtPP(:,Small_idx),'cubic');
                
                foamStar_dtPP{:,k}=data{start_idx:end_idx,1}+37; % 37 is the starting time in all cases(Hope so)
                PP_foamStar=data{start_idx:end_idx,2:end};
                
                for pp=2:8
                    foamStar_PP{:,pp,k} = PP_foamStar(:,pp)*0.01-obj.PP_static(pp);
                    
                end
                
                clear FileName data start_idx end_idx PP_foamStar 
            end
            
            %% Using Cross Correlation
   %% Finding the Interpolation time series
   
           for kk=1:obj.numcases
               foamStar_dt=foamStar_dtPP{:,kk};
               T_step(kk)=foamStar_dt(2)-foamStar_dt(1);
           end
           
           [Small_Value,Small_idx]=min(T_step);

           FigH = figure('Position', get(0, 'Screensize'));
   
        
          for i=2:8
              
            IExpt_yaxis=interp1(pl_time,PP_Expt(:,i),foamStar_dtPP{:,Small_idx},'cubic');
              
            for k=1:obj.numcases
            
                IP_Timeseries(:,k)=interp1(foamStar_dtPP{:,k},foamStar_PP{1,i,k},foamStar_dtPP{:,Small_idx},'cubic');
                
                %% Estimation single value in the Cross Correlation in Experiment
                [r(:,k),lags(:,k)]=xcorr(IP_Timeseries(:,k),IExpt_yaxis,'coeff');
                [~,I(:,k)]=max(abs(r(:,k)));
                Lag(:,k)=lags(I(:,k));
                Q4(i-1,k)=max(abs(r(:,k)));
                
            end
            
          end
          
               % figure()
               fontsize=36;
               hhh=2;
               markerSet='osp^>v<d*';
               % colorOrder = get(gca,'ColorOrder');
               cOrder = colormap(cbrewer('qual','Paired',obj.numcases));
               markersize = 32;
               linewidth = 4;
               rect = [3 5 30 18];
               rect2 = [3 5 30 18];
               rect3 = [3 5 20 16];
               mkrs=['o';'d']; 
               % fontsize = 18;
               
               for k=1:obj.numcases
                   
                   if(k<=obj.foamStarnumcases)
                       Gtype=1;
                   else
                       Gtype=2;
                   end
                   plot(obj.ccost(k),mean(Q4(:,k)),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(k,:))
                   set(gca,'fontsize',fontsize)
                   ylim1 = [10^(-0.01) 10^(0)];
                   ylim(ylim1)
                   xlim([10^4 10^7])
                   set(gca, 'YScale', 'log')
                   set(gca, 'XScale', 'log')
                   set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
                   ylabalis =sprintf('Cross Correlation  Coefficient');
                   ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
                   
                   xlabalis =sprintf('Computational cost (s)');
                   xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
                   hold on
               end
               
               hold off
               legend(obj.lgd{:},'interpreter','latex','Location','northwest','NumColumns',2)
               legend('boxon')
               % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
               title(['Pressure Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
               % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
               %     fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/CrossCorrleationError/';
               %    saveas(FigH, fullfile(fname, ['PPmean ']), 'jpeg');
               
               
              
         end
    
        
    end
    
    
    
    
end