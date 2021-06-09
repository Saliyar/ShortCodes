classdef RegularwavesInteraction
    
    properties 
         Exptloc
        Expt_probe
        HOS_Filelocation
        foamstarlocation
        exptdata
        HOSdata
        foamstardata
        fsprobes
        
    end
    
    
    methods
        
        function obj=RegularwavesInteraction(Expt_Filelocation,Expt_probe,foamstarlocation,fsprobes)
           obj.Exptloc=Expt_Filelocation; 
           obj.Expt_probe=Expt_probe;
           obj.foamstarlocation=foamstarlocation;
           obj.exptdata=load(Expt_Filelocation);
           obj.foamstardata=load(fullfile(foamstarlocation,'/postProcessing/waveProbe/0/surfaceElevation1.dat'));
           obj.fsprobes=fsprobes;
        end
        
        function plotfoamStarwaveprobe(obj)
            
            plot(obj.foamstardata(:,1),obj.foamstardata(:,(floor(length(obj.fsprobes)/2))),'LineWidth',3)
            %  xlim([0 70])
            ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title ('LC 3 - Probe WG','interpreter','latex','FontSize',32);
            grid on;
        end
             
        function comparisionVsfoamstar(obj)
            FigH = figure('Position', get(0, 'Screensize'));
            plot(obj.exptdata.data.wave.time,obj.exptdata.data.wave.elevation(:,obj.Expt_probe),'LineWidth',3)
            hold on
            %% foamStar probe finding 
            Expt_probe_location=[15 17 16.85 17 17.15 17.30  17.45 17.6];
           % fs_probes=-8.5:0.01:8.5;
            fs_probe_location=Expt_probe_location(obj.Expt_probe)-16.95;
            
            [d, ix] = min (abs(obj.fsprobes-fs_probe_location));
            foamstar_probe=ix+100 % 100 for Probe number starts from 100
            
            
            plot(obj.foamstardata(:,1),obj.foamstardata(:,foamstar_probe),'LineWidth',3) % 4 is the ref time used in foamstar, 0.44 found from graph!!
            xlim([0 110])
            ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title (['LC 3 - Probe WG',num2str(obj.Expt_probe)],'interpreter','latex','FontSize',32);
            legend ('Experiment','foamstar','interpreter','latex','FontSize',32);
            grid on;
            
        end
        function spectrumcomparision(obj)
            
            % Experiment Probe 
                h1=obj.exptdata.data.wave.elevation(:,obj.Expt_probe);
                dt_h=obj.exptdata.data.wave.time;
                
             % foamStar Probe and data
                Expt_probe_location=[15 17 16.85 17 17.15 17.30  17.45 17.6];
                fs_probe_location=Expt_probe_location(obj.Expt_probe)-16.95;
                [d, ix] = min (abs(obj.fsprobes-fs_probe_location));
                foamstar_probe=ix+100 % 100 for Probe number starts from 100
                h=obj.foamstardata(:,foamstar_probe);
                dt_foamstar=obj.foamstardata(:,1);
                
                % Take FFT from 20s for both foamstar and Expt 
                   Expt_timestep=dt_h(2)-dt_h(1);
                   foamstar_dt=dt_foamstar(2)-dt_foamstar(1);
                   
                  ExptStart=floor(20/Expt_timestep); %28.5 for 15 timestep after that
                  foamstarStart=floor(20/foamstar_dt);
                  
                  Exptend=floor(65/Expt_timestep);
                  foamstarend=floor(65/foamstar_dt);
                
                figure()
                set(gca,'Fontsize',32)
                subplot(2,1,1)
                plot(dt_h,h1,'LineWidth',3)
                hold on 
                plot(dt_foamstar-0.46,h,'LineWidth',3)
                ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',24)
                xlabel('Time [s]','interpreter','latex','FontSize',24)
                title(['Regular Wave at WG', num2str(obj.Expt_probe)],'interpreter','latex','FontSize',24)
                legend ('Experiment','foamstar','interpreter','latex','FontSize',24);
                xlim([20 60])
                grid on;
                grid minor;
                set(gca,'Fontsize',24)
                hold off
               
                subplot(2,1,2)
                [xfft,Abs_xfft]=takingfft(dt_h(ExptStart:Exptend),h1(ExptStart:Exptend));
                plot(xfft,Abs_xfft,'LineWidth',3)
                hold on;
                
               [xfft1,Abs_xfft1]=takingfft(dt_foamstar(foamstarStart:foamstarend),h(foamstarStart:foamstarend));
               
                plot(xfft1,Abs_xfft1,'LineWidth',3)
                
                xlim([0 1])
                grid on;
                grid minor;
                set(gca,'Fontsize',24)
                xlabel('Frequency (Hz)','interpreter','latex','FontSize',24)
                ylabel('Amplitude','interpreter','latex','FontSize',24)
                title('Frequency Domain signal','interpreter','latex','FontSize',24)
               legend ('Experiment','foamstar','interpreter','latex','FontSize',24);
                
                function [xfft,Abs_xfft]=takingfft(dt_h,h1)
                    dt_h1=dt_h-dt_h(1);
                    Fs=1/(dt_h(2)-dt_h(1));

                    ff=fft(h1);
                    fff=ff(1:length(ff)/2);

                    xfft=Fs*(0:length(ff)/2-1)/length(ff);

                    Abs_xfft = abs(fff)/length(xfft);
                    [~,idxmax] = max(Abs_xfft);
                   % Phase_max = angle(fff(idxmax));
                end
            
        end
        
    end
    
    
end
