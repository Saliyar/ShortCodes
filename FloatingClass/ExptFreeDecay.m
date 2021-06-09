%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
classdef ExptFreeDecay
    
    properties 
        dof
        Dof_Freedom
        selectedCase
        cropped_timestep
        
    end
    
    properties (Access=private)
        Expt_location
    end
    
    properties (Dependent)
        filename
        xyaxisdata
        CompleteData
        timestep
        croppingdata
        plot_croppingdata
        mean_dof
    end
    
   methods 
    % Constructor 
        function obj=ExptFreeDecay(Expt_dof,cropped_timestep)
        
            obj.dof=Expt_dof; 
            obj.Expt_location='/home/saliyar/PhD_SithikAliyar/SPAR/Experimental_Data/Decays';
            obj.Dof_Freedom={'Surge','Sway','Heave','Roll','Pitch'};
            obj.selectedCase=['Selected case,',obj.Dof_Freedom(obj.dof)];
            obj.cropped_timestep=cropped_timestep;
        end
    
        function filename=get.filename(obj)
                       
           switch(obj.dof) 
               case 1
                  
                   filename='Export4CFD_SW_SPAR_Group_EI_5_surge_decay_01.mat';
                case 2
          
                   filename='Export4CFD_SW_SPAR_decay_yaw_01_sway.mat';
                case 3

                   filename='Export4CFD_SW_SPAR_Group_M_5_heave_decay_01.mat';
                case 4
   
                   filename='Export4CFD_SW_SPAR_decay_yaw_01_roll.mat';
                case 5

                   filename='Export4CFD_SW_SPAR_ramp_steps_0_50_p_10.mat';              
               otherwise
                   disp('Not proper keyword or no file')
               
           end
            
        end
        
        function plotExptSingleCase(obj)
           
            DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
            load(DecayExpt_filename)
            dt_motion=data4CFD.time;
            ylbl={'motion(m)','rotation(rad)'};
            
            if(obj.dof <=3)
                pp=data4CFD.CoG_motion(:,obj.dof);
                ylbl_select=ylbl(1);
            else
                pp=data4CFD.CoG_rotation(:,obj.dof);
                ylbl_select=ylbl(2);
            end
            FigH = figure('Position', get(0, 'Screensize'));
            plot(dt_motion,pp,'LineWidth',3)
            
            ylabel(ylbl_select,'interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title ( [obj.Dof_Freedom(obj.dof),' Free Decay'],'interpreter','latex','FontSize',32);
            grid on;
            grid minor;
            hold off
            
            clear data4CFD;
        end
        
        function plotStackedCase(obj)
           DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
           load(DecayExpt_filename)
           dt_motion=data4CFD.time;
           pp_linear=data4CFD.CoG_motion;
           pp_rotation=data4CFD.CoG_rotation;
           
           %% Linear motion stacked plot
            
            FigH = figure('Position', get(0, 'Screensize'));
            newYlabels = {'Surge(m)','Sway(m)','Heave(m)'};
            s=stackedplot(dt_motion, pp_linear,'DisplayLabels' , newYlabels);
            s.LineWidth = 2;
            s.XLabel={'Time [s]'};
            s.FontSize = 25; 
            s.FontName='Arial';
            s.Title=[obj.Dof_Freedom(obj.dof),' Free Decay'];
            grid on;
        %
        %% Rotational motion stacked plot
        % 
            FigH = figure('Position', get(0, 'Screensize'));
            newYlabels = {'Roll(rad)','Pitch(rad)','Yaw(rad)'};
            s=stackedplot(dt_motion, pp_rotation,'DisplayLabels' , newYlabels);
            s.LineWidth = 2;
            s.XLabel={'Time [s]'};
            s.FontSize = 25; 
            s.FontName='Arial';
            s.Title=[obj.Dof_Freedom(obj.dof),' Free Decay'];
            grid on;
            
            clear data4CFD;
        end       
        
        function xyaxisdata=get.xyaxisdata(obj)
            DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
           
            load(DecayExpt_filename);
            xaxisdata=data4CFD.time;
            if(obj.dof <=3)
                yaxisdata=data4CFD.CoG_motion(:,obj.dof);
            else
                yaxisdata=data4CFD.CoG_rotation(:,obj.dof);
            end 
            xyaxisdata=[xaxisdata yaxisdata];
            clear data4CFD;
        end
        
        function CompleteData=get.CompleteData(obj)
            
           DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
           load(DecayExpt_filename); 
           CompleteData=[data4CFD.time data4CFD.CoG_motion data4CFD.CoG_rotation]; 
        end
            
        function timestep=get.timestep(obj)
            DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
            load(DecayExpt_filename); 
            timestep=data4CFD.time(2)-data4CFD.time(1);
            ff=1/timestep;
            % fprintf('The Sampling Freq used is %f Hz',ff);
           
        end
         
        function croppingdata=get.croppingdata(obj)
            
            DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
           
            load(DecayExpt_filename);
            xaxisdata=data4CFD.time(obj.cropped_timestep:end)-data4CFD.time(obj.cropped_timestep);
            
            ylbl={'motion(m)','rotation(rad)'};
            
            if(obj.dof <=3)
                yaxisdata=data4CFD.CoG_motion(obj.cropped_timestep:end,obj.dof);
                yaxisdata=yaxisdata-yaxisdata(1);
                ylbl_select=ylbl(1);
            else
                yaxisdata=data4CFD.CoG_rotation(obj.cropped_timestep:end,obj.dof)-data4CFD.CoG_rotation(obj.cropped_timestep);
                ylbl_select=ylbl(2);
            end 
            croppingdata=[xaxisdata yaxisdata];
            
%             FigH = figure('Position', get(0, 'Screensize'));
%             plot(xaxisdata,yaxisdata,'LineWidth',3)
%             
%             ylabel(ylbl_select,'interpreter','latex','FontSize',32)
%             xlabel('Time [s]','interpreter','latex','FontSize',32)
%             set(gca,'Fontsize',32)
%             title ( [obj.Dof_Freedom(obj.dof),' Free Decay'],'interpreter','latex','FontSize',32);
%             grid on;
%             grid minor;
%             hold off
            
            clear data4CFD;
        end
        
        function mean_dof=get.mean_dof(obj)
            DecayExpt_filename=fullfile(obj.Expt_location,obj.filename);
            load(DecayExpt_filename); 
            
            if(obj.dof <=3)
                yaxisdata=data4CFD.CoG_motion(:,obj.dof);
                yaxisdata_cropped=data4CFD.CoG_motion(obj.cropped_timestep:end,obj.dof);
                yaxisdata=yaxisdata-yaxisdata(1);
                yaxisdata_cropped=yaxisdata_cropped-yaxisdata_cropped(1);

            else
                
                yaxisdata=data4CFD.CoG_rotation(:,obj.dof);
                yaxisdata_cropped=data4CFD.CoG_rotation(obj.cropped_timestep:end,obj.dof);
                yaxisdata=yaxisdata-yaxisdata(1);
                yaxisdata_cropped=yaxisdata_cropped-yaxisdata_cropped(1);

            end 
            
            mean_dof=mean(yaxisdata_cropped)-0.045;
            mean_uncropped=mean(yaxisdata)-0.045;
            X = sprintf('%f is the cropped data mean \n %f is the uncropped data mean',mean_dof,mean_uncropped);
            disp(X);
           
        end
                   
   end
    
end
