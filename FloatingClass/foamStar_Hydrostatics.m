%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the Class to plot the Hydrostatics motion
classdef foamStar_Hydrostatics
   properties 
       foamStar_location
       dof
   end
   
   properties (Dependent)
      mean_foamStar 
   end
    
   methods
       
       % Constructor 
       function obj=foamStar_Hydrostatics(loc,dof)
                
                obj.foamStar_location=loc;
                obj.dof=dof;
       end
       
        function plotSingleCase(obj)
                          
               foamStar_filename=obj.foamStar_location;
               foamStarfullfile=string(fullfile(foamStar_filename,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion=data{:,1};
               motion_foamStar=data{:,2:end};
               pp_linear=[motion_foamStar(:,1) motion_foamStar(:,2) motion_foamStar(:,3)];
               pp_rotation=[motion_foamStar(:,4) motion_foamStar(:,5) motion_foamStar(:,6)];
               
               FigH = figure('Position', get(0, 'Screensize'));
                newYlabels = {'Surge(m)','Sway(m)','Heave(m)'};
                s=stackedplot(dt_motion, pp_linear,'DisplayLabels' , newYlabels);
                s.LineWidth = 2;
                s.XLabel={'Time [s]'};
                s.FontSize = 25; 
                s.FontName='Arial';
                % s.Title='Hydrostatics -foamStar';
                grid on;
                
                 
                
                FigH = figure('Position', get(0, 'Screensize'));
                newYlabels = {'Roll(rad)','Pitch(rad)','Yaw(rad)'};
                s=stackedplot(dt_motion, pp_rotation,'DisplayLabels' , newYlabels);
                s.LineWidth = 2;
                s.XLabel={'Time [s]'};
                s.FontSize = 25; 
                s.FontName='Arial';
               % s.Title='Hydrostatics -foamStar';
                grid on;
                
        end
        
        function mean_foamStar=get.mean_foamStar(obj)
         foamStar_filename=obj.foamStar_location;
               foamStarfullfile=string(fullfile(foamStar_filename,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion=data{:,1};
               motion_foamStar=data{:,obj.dof+1};
               mean_foamStar=mean(motion_foamStar);
               
               plot(dt_motion,motion_foamStar,'LineWidth',3)
               hold on 
               yline(mean_foamStar,'-','mean','LineWidth',3);
               ylabel('motion','interpreter','latex','FontSize',32)
               xlabel('Time [s]','interpreter','latex','FontSize',32)
               set(gca,'Fontsize',32)
               title ( ' Hydrostatics with mean','interpreter','latex','FontSize',32);
               grid on;
               grid minor;
               hold off
              
           end
       
       
   end
   
   
end
