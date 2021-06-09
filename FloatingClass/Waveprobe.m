classdef Waveprobe
    
    properties
        Exptloc
        Expt_probe
        HOS_Filelocation
        foamstarlocation
        exptdata
        HOSdata
        foamstardata
    end
    
    methods
        
        function obj=Waveprobe(ExptIrr_Filelocation,Expt_probe,HOS_Filelocation,foamstarlocation)
           obj.Exptloc=ExptIrr_Filelocation; 
           obj.Expt_probe=Expt_probe;
           obj.HOS_Filelocation=HOS_Filelocation;
           obj.foamstarlocation=foamstarlocation;
           obj.exptdata=load(ExptIrr_Filelocation);
           obj.HOSdata=importdata(fullfile(HOS_Filelocation,'probes1.dat'));
           obj.foamstardata=load(fullfile(foamstarlocation,'/postProcessing/waveProbe/0/surfaceElevation1.dat'));
        end
        
%         function plotExptwaveprobe
%             
%         end
%         
%         function plotHOSwaveprobe 
%             
%         end
%         
        function plotfoamStarwaveprobe(obj)
            
            plot(obj.foamstardata(:,1),obj.foamstardata(:,obj.foamstar_probe),'LineWidth',3)
            %  xlim([0 70])
            ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title ('LC 3 - Probe WG','interpreter','latex','FontSize',32);
            grid on;
        end
        
        function comparision_ExptVsHOS(obj)
            
            FigH = figure('Position', get(0, 'Screensize'));
           
            plot(obj.exptdata.data.wave.time,obj.exptdata.data.wave.elevation(:,obj.Expt_probe),'LineWidth',3)
            hold on
            plot(obj.HOSdata(:,1),obj.HOSdata(:,obj.Expt_probe+1),'LineWidth',3) % 0.89 Phase shift, +1 is for time and probe data
            xlim([0 300])
            ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title (['LC 3 - Probe WG',num2str(obj.Expt_probe)],'interpreter','latex','FontSize',32);
            legend ('Experiment','HOS ','interpreter','latex','FontSize',32);
            grid on;
            
        end
        
        function comparision_HOSVsfoamstar(obj)
            FigH = figure('Position', get(0, 'Screensize'));
            plot(obj.exptdata.data.wave.time,obj.exptdata.data.wave.elevation(:,obj.Expt_probe),'LineWidth',3)
            hold on
            plot(obj.HOSdata(:,1)-0.9,obj.HOSdata(:,obj.Expt_probe+1),'LineWidth',3) % 0.89 Phase shift, +1 is for time and probe data
            hold on
            %% foamStar probe finding 
            Expt_probe_location=[15 17 16.85 17 17.15 17.30  17.45 17.6];
            fs_probes=-8.5:0.01:8.5;
            fs_probe_location=Expt_probe_location(obj.Expt_probe)-16.95;
            
            [d, ix] = min (abs(fs_probes-fs_probe_location));
            foamstar_probe=ix+100 % 100 for Probe number starts from 100
            
            
            
            plot(obj.foamstardata(:,1)+0.9,obj.foamstardata(:,foamstar_probe),'LineWidth',3) % 4 is the ref time used in foamstar, 0.44 found from graph!!
            xlim([0 110])
            ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title (['LC 3 - Probe WG',num2str(obj.Expt_probe)],'interpreter','latex','FontSize',32);
            legend ('Experiment','HOS ','foamstar','interpreter','latex','FontSize',32);
            grid on;
            
        end
%         
%         function comparision_ExptVsHOSVsfoamStar
%             
%         end
        
    end
    
    
end
