%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the Class to plot the Hydrostatics motion
classdef foamStar_Hydrostatics
   properties 
       foamStar_location
       
   end
   
    
   methods
       
       % Constructor 
       function obj=foamStar_Hydrostatics(loc)
                
                obj.foamStar_location=loc;
       end
       
        function plotSingleCase(obj)
           FigH = figure('Position', get(0, 'Screensize'));
                       
               foamStar_filename=obj.foamStar_location;
               foamStarfullfile=string(fullfile(foamStar_filename,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion
               pp_linear=[motion_foamStar(:,1) motion_foamStar(:,2) motion_foamStar(:,3)];
               pp_rotation=[motion_foamStar(:,4) motion_foamStar(:,5) motion_foamStar(:,6)];
               FigH = figure('Position', get(0, 'Screensize'));
                newYlabels = {'Surge(m)','Sway(m)','Heave(m)'};
                s=stackedplot(dt_motion, pp_linear,'DisplayLabels' , newYlabels);
                s.LineWidth = 2;
                s.XLabel={'Time [s]'};
                s.FontSize = 25; 
                s.FontName='Arial';
                s.Title='Hydrostatics -foamStar';
                grid on;
                 
                
                FigH = figure('Position', get(0, 'Screensize'));
                newYlabels = {'Roll(rad)','Pitch(rad)','Yaw(rad)'};
                s=stackedplot(dt_motion, pp_rotation,'DisplayLabels' , newYlabels);
                s.LineWidth = 2;
                s.XLabel={'Time [s]'};
                s.FontSize = 25; 
                s.FontName='Arial';
                s.Title='Hydrostatics -foamStar';
                grid on;
        end
       
       
   end
   
   
end
