%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
classdef foamStarHeaveFreeDecay
    
    properties 
        no_of_cases
        selection
        selected_Folder
        legend_foamstar
    end
    
    properties (Access=private)
        foamStar_location
        Expt_Heave_amp
        Expt_Heave_natPeriod
        Exptdata
        
    end
    
    properties (Dependent)
        
        filename
        mean_foamStar
        
    end
    
   methods 
    % Constructor 
        function obj=foamStarHeaveFreeDecay(Number_of_cases,Selection,SelectedFolder,expt_cropped_data,lgd)
            obj.no_of_cases=Number_of_cases;
            obj.selection=Selection;
            obj.foamStar_location='/home/saliyar/PhD_SithikAliyar/SPAR/foamStar_Data/FreeDecay/HeaveFD/MeshRefinmentStudy/';
            obj.Expt_Heave_amp=0.045;
            obj.Expt_Heave_natPeriod=4.85;
            obj.selected_Folder=SelectedFolder;
            obj.Exptdata=expt_cropped_data;
            obj.legend_foamstar=lgd;
        end
    
        function filename=get.filename(obj)
            
           switch(obj.selection) 
               case 1
                  
                   filename='SRefinementLvl';
                case 2
          
                   filename='BottomBoxLevel';
                case 3

                   filename='SPARBox';
                case 4
   
                   filename='OuterBox';
                case 5

                   filename='SPAR_Lvl';
               
                case 6   
                    
                   filename='foamStarPPSD35SL4';
               case  7
                   filename='SRefinementLvl';
               case 8
                   filename='Scheme';
               case 9
                   filename='Turb';
               case 10
                   filename='Co';
                
               otherwise
                   disp('Not proper keyword or no file')          
           end         
        end
        
        function plotSingleCase(obj)
           FigH = figure('Position', get(0, 'Screensize'));
           for i=1:obj.no_of_cases
               
               foamStar_filename1=fullfile(obj.foamStar_location,obj.selected_Folder,filesep,obj.filename);
               foamStar_filename2=strcat(foamStar_filename1, num2str(i));
               foamStarfullfile=string(fullfile(foamStar_filename2,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion_foamstar=data{:,1}; 
               motion_foamStar=data{:,4};
               % lgd{i}=strcat(obj.filename,num2str(i));
               % Plot 
                plot(dt_motion_foamstar/obj.Expt_Heave_natPeriod,motion_foamStar/obj.Expt_Heave_amp,'LineWidth',3)
                ylabel('$z/\eta_a$','interpreter','latex','FontSize',32)
                xlabel('$t/T_p$','interpreter','latex','FontSize',32)
                set(gca,'Fontsize',32)
                title ( 'Heave Free Decay','interpreter','latex','FontSize',32);
                
                grid on;
                grid minor;
                hold on
           end
           legend (obj.legend_foamstar(:),'interpreter','latex','FontSize',32)
           hold off  
        end
       
        function plotExptVsfoamStar_singleCase(obj)
         
            FigH = figure('Position', get(0, 'Screensize'));
           for i=1:obj.no_of_cases
               
               foamStar_filename1=fullfile(obj.foamStar_location,obj.selected_Folder,filesep,obj.filename);
               foamStar_filename2=strcat(foamStar_filename1, num2str(i));
               foamStarfullfile=string(fullfile(foamStar_filename2,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion_foamstar=data{:,1}; 
               motion_foamStar=data{:,4};
               % lgd{i}=strcat(obj.filename,num2str(i));
              mean_foamStar1=mean((motion_foamStar-obj.Expt_Heave_amp)/obj.Expt_Heave_amp);
      
               % Plot 
                plot(dt_motion_foamstar/obj.Expt_Heave_natPeriod,((motion_foamStar-obj.Expt_Heave_amp)/obj.Expt_Heave_amp),'LineWidth',3)
                ylabel('$z/\eta_a$','interpreter','latex','FontSize',32)
                xlabel('$t/T_p$','interpreter','latex','FontSize',32)
                set(gca,'Fontsize',32)
                title ( 'Heave Free Decay','interpreter','latex','FontSize',32);
                
                grid on;
                grid minor;
                hold on
           end
            Expt_data=obj.Exptdata;
            Expt_time=Expt_data(:,1);
            Expt_yaxis=Expt_data(:,2);
            mean_expt=mean((Expt_yaxis-obj.Expt_Heave_amp)/obj.Expt_Heave_amp);
            plot(Expt_time/obj.Expt_Heave_natPeriod,(Expt_yaxis-obj.Expt_Heave_amp)/obj.Expt_Heave_amp,'--','color',([0 0 0]),'LineWidth',3)
            %lgd{i+1}='Experiment';
           legend (obj.legend_foamstar(:),'interpreter','latex','FontSize',32)
           xlim([0 5])
           
           hold off 
        end
        
         function mean_foamStar=get.mean_foamStar(obj)
         
           for i=1:obj.no_of_cases
               
               foamStar_filename1=fullfile(obj.foamStar_location,obj.selected_Folder,filesep,obj.filename);
               foamStar_filename2=strcat(foamStar_filename1, num2str(i));
               foamStarfullfile=string(fullfile(foamStar_filename2,'/postProcessing/motionInfo/0/cylinder1.dat'));
               data=readtable(foamStarfullfile);
               dt_motion_foamstar=data{:,1}; 
               motion_foamStar=data{:,4};
               
               % mean_foamStar(i)=mean((motion_foamStar-obj.Expt_Heave_amp)/obj.Expt_Heave_amp)
               mean_foamStar(i)=mean(motion_foamStar)-0.045;
              
           end
 

        end
        
   end
    
end
