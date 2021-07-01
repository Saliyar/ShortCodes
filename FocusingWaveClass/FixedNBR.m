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
        numSWENSEadvantage
        total2Dcases
    end
    
    properties (Access=private)
        Exptlocation
        ExptIndices
        foamStarSWENSE_rootFolder
        foamStarTestcases
        PP_static
        FolderDestination
        HOSloc
        foamStar2Dloc
        SWENSE2Dloc
        
    end
    
    properties (Dependent)
        
    end
    
    methods
      
        % Constructor 
        function obj=FixedNBR(RanStartTime,RanEndTime,numfoamStarcases,numSWENSEcases,nstart,nend,cps,lgd,ccost,numSWENSEadvantage,total2Dcases)
            
          obj.Exptlocation=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Experiment/Case23003/','catA_23003.mat');
          obj.ExptIndices=RanStartTime*100+2:RanEndTime*100+2; % Based on earlier study
          obj.foamStarSWENSE_rootFolder=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/Fixed_NBR_focusing');
          obj.foamStarnumcases=numfoamStarcases;
          obj.SWENSEnumcases=numSWENSEcases;
          obj.numSWENSEadvantage=numSWENSEadvantage;
          obj.numcases=numfoamStarcases+numSWENSEcases+numSWENSEadvantage;
          obj.nstart=nstart;
          obj.nend=nend;
          obj.PP_static=[0 17.93 8.49 0 0 8.49 8.49 8.49];
          obj.cps=cps;  
          obj.FolderDestination='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Graphs';
          obj.Exptforcepath=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/Experiment/Case23003/','cylinnonbreak23003_2ndorder_9600Hz.MAT');
          obj.ExptforceIndices=355212:403205;
          obj.lgd=lgd;
          obj.ccost=ccost;
          obj.HOSloc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/FinalResults/3DFixedNBRCylinder/HOS/probes1.dat';
          obj.foamStar2Dloc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/foamStar_2D_ParamtericStudy';
          obj.SWENSE2Dloc='/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/SWENSE2DStudy';
          obj.total2Dcases=total2Dcases;
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
        
        function HOSExptWaveComp(obj)
            
            %% Loading Experiment data
            load(obj.Exptlocation)
            ExptHOSindex=1:5000;

            WP_Expt=[wp1(ExptHOSindex,2) wp2(ExptHOSindex,2) wp3(ExptHOSindex,2) wp4(ExptHOSindex,2) wp5(ExptHOSindex,2) wp6(ExptHOSindex,2) wp7(ExptHOSindex,2)];

            pl_time=wp5(ExptHOSindex,1);   %Added for checking full time series of experiment
            
            clear pp* wp*
            m
             %% Loading HOS data
            
            HOSdata=load(obj.HOSloc);          
            
            for i=1:7
            FigH = figure('Position', get(0, 'Screensize'));
            plot(pl_time-obj.cps,WP_Expt(:,i),'--','Color','k','LineWidth',3) % Costant phase shift is substracted
            
            hold on
            
            plot(HOSdata(:,1),HOSdata(:,i+1))
            
            xlim([37 42])
            ylabel('Surface Elevation [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title(['WP ',num2str(i)],'interpreter','latex','FontSize',32)
            legend('Experiment','HOS','interpreter','latex','FontSize',32)
            grid on;
            end
            
            %% Cross Correlation Initiation 
            
            
            for k=1:7
              
                IHOS_yaxis=interp1(HOSdata(:,1),HOSdata(:,k+1),pl_time,'cubic');      
                
                %% Estimation single value in the Cross Correlation in Experiment
                [r(:,k),lags(:,k)]=xcorr(WP_Expt(:,k),IHOS_yaxis,'coeff');
                [~,I(:,k)]=max(abs(r(:,k)));
                Lag(:,k)=lags(I(:,k));
                Q4(:,k)=max(abs(r(:,k)));
            
            end
            
          disp('The mean of all wave probes CCoefficient is :');
          mean(Q4);
            
            
        end
        
        function SWENSEBottomBoundaryconditionCheck(obj)
            
            
            SWENSE_Basename=fullfile('/home/sithik/Documents/PhDTestCases/CylinderFocusingWave/SWENSE2DStudy/Boundary_condition_study','SWENSETestcase');
            
             for k=1:3 % 3 cases being tested
            
                 FileName=[SWENSE_Basename,num2str(k)];

                foamStarfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
                data=readtable(foamStarfullfile);
                
                
                foamStar_dtPP(:,k)=data{:,1}+37; % 37 is the starting time in all cases(Hope so)
                PP_foamStar=data{:,2:end};
                
                for pp=1:3
                    foamStar_PP(:,pp,k) = PP_foamStar(:,pp);
                    
                end
                clear FileName data start_idx end_idx PP_foamStar  
             end
             whos foamStar_PP
            
            %% Plot 
          for i=1:3
            
              FigH = figure('Position', get(0, 'Screensize'));
              
            for k=1:3 
            plot(foamStar_dtPP(:,k),foamStar_PP(:,i,k),'LineWidth',3);     
            hold on ;                
            end
            % xlim([37+obj.nstart 37+obj.nend])
            ylabel('Surface Elevation [m]','interpreter','latex','FontSize',32)
            xlabel('Time [s]','interpreter','latex','FontSize',32)
            set(gca,'Fontsize',32)
            title(['WP ',num2str(i+4)],'interpreter','latex','FontSize',32)
            grid on;
            % grid minor;
            
            legend('Slip','WaveVelocitySWENSE','Fixed Value 0','interpreter','latex','Location','northwest','NumColumns',1)
            % SavingFile=fullfile(obj.FolderDestination,['WP',num2str(i+4)]);
            % saveas(FigH, SavingFile,'epsc');
          end
            
            
        end
        
        
        
        
        
        function foamStar2DWaveprobecomparision(obj)
           
        %% Loading HOS data    
            
            HOSdata=load(obj.HOSloc);  
            dt_HOS=HOSdata(:,1);
            Eta_HOS=HOSdata(:,2:end);
            
         %% Gettting datas from foamStar 2D cases
         VarCo = {'0.1','0.25','0.5','0.75','1'};
         VarDelta={'10','25','50','75','100'};
         n=1; % Number of iteration
         probe_location_cfd=2;
         
         Filepath_perm=fullfile(obj.foamStar2Dloc,['foamStar2D_Dx',VarDelta{1},'MeshCo',VarCo{1}],'postProcessing','waveProbe','0','surfaceElevation.dat');
         Initialdata2=readtable(Filepath_perm);
         Initialdata2{:,1}=Initialdata2{:,1}+34;
         [strVal,start_idx]=min(abs(35-Initialdata2{:,1}));
         [endVal,end_idx]=min(abs(45-Initialdata2{:,1}));
         data2=Initialdata2{start_idx:end_idx,:};
         data2(:,1)=data2(:,1)-data2(1,1);
         dt=data2(1,1)-data2(2,1);

         for i=1:length(VarDelta)
             for j=1:length(VarCo)

                 Filepath=fullfile(obj.foamStar2Dloc,['foamStar2D_Dx',VarDelta{i},'MeshCo',VarCo{j}],'postProcessing','waveProbe','0','surfaceElevation.dat');
                 Initialdata1=readtable(Filepath); 
                 
                 if (i==1 && j==1)
                     Initialdata1{:,1}=Initialdata1{:,1}+34;  
                 end
                 
                 [strVal,start_idx]=min(abs(35-Initialdata1{:,1}));
                 [endVal,end_idx]=min(abs(45-Initialdata1{:,1}));
                 data1=Initialdata1{start_idx:end_idx,:};
                 data1(:,1)=data1(:,1)-data1(1,1);
                 
                 Eta=interp1(data1(:,1),data1(:,probe_location_cfd+1),data2(:,1),'spline');
                 Eta_foamStar(:,n)=Eta;
                 n=n+1;
             end
         end
         whos Eta_foamStar
         
         %% Step 4: Interpolating HOS file and loading that into foamStar matrix  like 6th coloumn
         [strVal,start_idx]=min(abs(35-dt_HOS(:,1)));
         [endVal,end_idx]=min(abs(45-dt_HOS(:,1)));
         dt_HOS=dt_HOS(start_idx:end_idx,1);
         dt_HOS(:,1)=dt_HOS(:,1)-dt_HOS(1,1);
         Y_axis_HOS=interp1(dt_HOS,Eta_HOS(start_idx:end_idx,probe_location_cfd+4),data2(:,1),'spline');
%          plot(Y_axis_HOS)
%          Eta_foamStar(:,n)=Y_axis_HOS;
         
         %% Obtaining Error Estimation using cross correlation between
         
%          [strVal,start_idx]=min(abs(35-data2{:,1}))
%          [endVal,end_idx]=min(abs(45-data2{:,1}))
%                 
%          
%          Time_index=start_idx:end_idx;
%          %Obtaining time step from the given
%          dt=data2{2,1}-data2{1,1};
%          Eta_foamStar_extracted_window=Eta_foamStar(Time_index,:);
%         
         for i=1:length(VarCo)+length(VarDelta)
             
             [r(:,i),lags(:,i)]=xcorr(Eta_foamStar(:,i),Y_axis_HOS,'coeff');
             [~,I(:,i)]=max(abs(r(:,i)));
             Lag(:,i)=lags(I(:,i));
             rmax(i,:)=max(abs(r(:,i)));
         end
         
         %% Plotting the Correlation between the Sets
         figure()
         for i=1:5:25
             
             plot(rmax(i:i+4,:),'-o','LineWidth',3)
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','FontSize',32)
             ylabel('Coefficient Correlation','FontSize',32)
             set(gca,'Fontsize',32)
             grid on;
             hold on
         end
         legend('Dx10','Dx25','Dx50','Dx75','Dx100','interpreter','latex','Location','northwest','NumColumns',1,'FontSize',32);
         hold off
         
         
         
         %% Plot for Phase shift estimation
         figure()
         for i=1:5:25
             plot(Lag(:,i:i+4)*dt,'-o','LineWidth',3)
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','FontSize',32)
             ylabel('Phase shift(s)','FontSize',32)
             set(gca,'Fontsize',32)
             grid on;
             hold on
         end
         legend('Dx10','Dx25','Dx50','Dx75','Dx100','FontSize',32);
         hold off
         
         %% Plotting the Time series between window for 35s to 15s
         
         figure()
         
         for i=1:25
             plot(data2(:,1),Eta_foamStar(:,i),'LineWidth',2)
             hold on;
             % xlim([35 45])
             ylabel('surface elevation [m]','FontSize',32)
             xlabel('Time [s]','FontSize',32)
             set(gca,'Fontsize',32)
             
             grid on;
         end
         % legend ('Dx100Co1','Dx100Co 0.75','Dx100Co 0.5','Dx100Co 0.25','Dx100Co 0.1','HOS','FontSize',32);
         hold off;
     
            
        end
        
        
        function SWENSE2DWaveprobecomparision(obj)
           
        %% Loading HOS data    
            
            HOSdata=load(obj.HOSloc);  
            dt_HOS=HOSdata(:,1);
            Eta_HOS=HOSdata(:,2:end);
            
         %% Gettting datas from foamStar 2D cases
         VarCo = {'0.1','0.25','0.5','0.75','1'};
         VarDelta={'25','50','75','100'};
         n=1; % Number of iteration
         probe_location_cfd=2;
         
         Filepath_perm=fullfile(obj.SWENSE2Dloc,['SWENSE2D_Dx',VarDelta{1},'MeshCo',VarCo{1}],'postProcessing','waveProbe','0','surfaceElevation.dat');
         data2=readtable(Filepath_perm);
         dt=data2{2,1}-data2{1,1};

         for i=1:length(VarDelta)
             for j=1:length(VarCo)

                 Filepath=fullfile(obj.SWENSE2Dloc,['SWENSE2D_Dx',VarDelta{i},'MeshCo',VarCo{j}],'postProcessing','waveProbe','0','surfaceElevation.dat');
                 Initialdata1=readtable(Filepath); 
                 
                 if (i==4)
                     Initialdata1{:,1}=Initialdata1{:,1}; 
                     [strVal,start_idx]=min(abs(35-Initialdata1{:,1}));
                     [endVal,end_idx]=min(abs(45-Initialdata1{:,1}));
                      data1=Initialdata1{start_idx:end_idx,:};
                      data1(:,1)=data1(:,1)-data1(1,1);
                 else
                     data1=Initialdata1{:,:};
                 end
 
                 Eta=interp1(data1(:,1),data1(:,probe_location_cfd+1),data2{:,1},'spline');
                 Eta_foamStar(:,n)=Eta;
                 n=n+1;
             end
         end
         whos Eta_foamStar
         
         
         %% Step 4: Interpolating HOS file and loading that into foamStar matrix  like 6th coloumn
         [strVal,start_idx]=min(abs(35-dt_HOS(:,1)));
         [endVal,end_idx]=min(abs(45-dt_HOS(:,1)));
         dt_HOS=dt_HOS(start_idx:end_idx,1);
         dt_HOS(:,1)=dt_HOS(:,1)-dt_HOS(1,1);
         Y_axis_HOS=interp1(dt_HOS,Eta_HOS(start_idx:end_idx,probe_location_cfd+4),data2{:,1},'spline');
%          plot(Y_axis_HOS)
%          Eta_foamStar(:,n)=Y_axis_HOS;
%          pause
         
         %% Obtaining Error Estimation using cross correlation between
         
%          [strVal,start_idx]=min(abs(35-data2{:,1}))
%          [endVal,end_idx]=min(abs(45-data2{:,1}))
%                 
%          
%          Time_index=start_idx:end_idx;
%          %Obtaining time step from the given
%          dt=data2{2,1}-data2{1,1};
%          Eta_foamStar_extracted_window=Eta_foamStar(Time_index,:);
%         
         for i=1:length(VarCo)*length(VarDelta)
             
             [r(:,i),lags(:,i)]=xcorr(Eta_foamStar(:,i),Y_axis_HOS,'coeff');
             [~,I(:,i)]=max(abs(r(:,i)));
             Lag(:,i)=lags(I(:,i));
             rmax(i,:)=max(abs(r(:,i)));
         end
         
         %% Plotting the Correlation between the Sets
         figure()
         for i=1:5:20
             
             plot(rmax(i:i+4,:),'-o','LineWidth',3)
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','interpreter','latex','FontSize',32)
             ylabel('Coefficient Correlation','interpreter','latex','FontSize',32)
             set(gca,'Fontsize',32)
             grid on;
             hold on
         end
         legend('Dx25','Dx50','Dx75','Dx100','interpreter','latex','Location','northwest','NumColumns',2,'FontSize',32);
         hold off
         
         
         
         %% Plot for Phase shift estimation
         figure()
         for i=1:5:20
             plot(Lag(:,i:i+4)*dt,'-o','LineWidth',3)
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','FontSize',32)
             ylabel('Phase shift(s)','FontSize',32)
             set(gca,'Fontsize',32)
             grid on;
             hold on
         end
         legend('Dx10','Dx25','Dx50','Dx75','Dx100','FontSize',32);
         hold off
         
         %% Plotting the Time series between window for 35s to 45s
         
         figure()
         
         for i=1:20
             plot(data2{:,1},Eta_foamStar(:,i),'LineWidth',2)
             hold on;
             % xlim([35 45])
             ylabel('surface elevation [m]','FontSize',32)
             xlabel('Time [s]','FontSize',32)
             set(gca,'Fontsize',32)
             
             grid on;
         end
         % legend ('Dx100Co1','Dx100Co 0.75','Dx100Co 0.5','Dx100Co 0.25','Dx100Co 0.1','HOS','FontSize',32);
         hold off;
     
            
        end
        
        function foamStarandSWENSE2DWaveprobecomparision(obj)
           
        %% Loading HOS data    
            
            HOSdata=load(obj.HOSloc);  
            dt_HOS=HOSdata(:,1);
            Eta_HOS=HOSdata(:,2:end);
            
         %% Gettting datas from foamStar 2D cases
         VarCo = {'0.1','0.25','0.5','0.75','1'};
         VarDelta={'10','25','50','75','100'};
         n=1; % Number of iteration
         probe_location_cfd=2;
         
         Filepath_perm=fullfile(obj.foamStar2Dloc,['foamStar2D_Dx',VarDelta{1},'MeshCo',VarCo{1}],'postProcessing','waveProbe','0','surfaceElevation.dat');
         Initialdata2=readtable(Filepath_perm);
         Initialdata2{:,1}=Initialdata2{:,1}+34;
         [strVal,start_idx]=min(abs(35-Initialdata2{:,1}));
         [endVal,end_idx]=min(abs(45-Initialdata2{:,1}));
         data2=Initialdata2{start_idx:end_idx,:};
         data2(:,1)=data2(:,1)-data2(1,1);
         dt=data2(1,1)-data2(2,1);

         for i=1:length(VarDelta)
             for j=1:length(VarCo)

                 Filepath=fullfile(obj.foamStar2Dloc,['foamStar2D_Dx',VarDelta{i},'MeshCo',VarCo{j}],'postProcessing','waveProbe','0','surfaceElevation.dat');
                 Initialdata1=readtable(Filepath); 
                 
                 if (i==1 && j==1)
                     Initialdata1{:,1}=Initialdata1{:,1}+34;  
                 end
                 
                 [strVal,start_idx]=min(abs(35-Initialdata1{:,1}));
                 [endVal,end_idx]=min(abs(45-Initialdata1{:,1}));
                 data1=Initialdata1{start_idx:end_idx,:};
                 data1(:,1)=data1(:,1)-data1(1,1);
                 
                 Eta=interp1(data1(:,1),data1(:,probe_location_cfd+1),data2(:,1),'spline');
                 Eta_foamStar(:,n)=Eta;
                 n=n+1;
             end
         end
         
         %% Loading SWENSE data 
         
         for i=2:length(VarDelta)
             for j=1:length(VarCo)

                 Filepath=fullfile(obj.SWENSE2Dloc,['SWENSE2D_Dx',VarDelta{i},'MeshCo',VarCo{j}],'postProcessing','waveProbe','0','surfaceElevation.dat');
                 Initialdata1=readtable(Filepath); 
                 
                 if (i==5)
                     Initialdata1{:,1}=Initialdata1{:,1}; 
                     [strVal,start_idx]=min(abs(35-Initialdata1{:,1}));
                     [endVal,end_idx]=min(abs(45-Initialdata1{:,1}));
                      data1=Initialdata1{start_idx:end_idx,:};
                      data1(:,1)=data1(:,1)-data1(1,1);
                 else
                     data1=Initialdata1{:,:};
                 end
 
                 Eta=interp1(data1(:,1),data1(:,probe_location_cfd+1),data2(:,1),'spline');
                 Eta_foamStar(:,n)=Eta;
                 n=n+1;
             end
         end   
         
         whos Eta_foamStar
         
         %% Step 4: Interpolating HOS file and loading that into foamStar matrix  like 6th coloumn
         [strVal,start_idx]=min(abs(35-dt_HOS(:,1)));
         [endVal,end_idx]=min(abs(45-dt_HOS(:,1)));
         dt_HOS=dt_HOS(start_idx:end_idx,1);
         dt_HOS(:,1)=dt_HOS(:,1)-dt_HOS(1,1);
         Y_axis_HOS=interp1(dt_HOS,Eta_HOS(start_idx:end_idx,probe_location_cfd+4),data2(:,1),'spline');
%          plot(Y_axis_HOS)
%          Eta_foamStar(:,n)=Y_axis_HOS;
         
         %% Obtaining Error Estimation using cross correlation between
         
%          [strVal,start_idx]=min(abs(35-data2{:,1}))
%          [endVal,end_idx]=min(abs(45-data2{:,1}))
%                 
%          
%          Time_index=start_idx:end_idx;
%          %Obtaining time step from the given
%          dt=data2{2,1}-data2{1,1};
%          Eta_foamStar_extracted_window=Eta_foamStar(Time_index,:);
%         
         for i=1:obj.total2Dcases
             
             [r(:,i),lags(:,i)]=xcorr(Eta_foamStar(:,i),Y_axis_HOS,'coeff');
             [~,I(:,i)]=max(abs(r(:,i)));
             Lag(:,i)=lags(I(:,i));
             rmax(i,:)=max(abs(r(:,i)));
         end
         
         %% Plotting the Correlation between the Sets
         
         fontsize=36;
         hhh=2;
         markerSet='osp^>v<d*';
         % colorOrder = get(gca,'ColorOrder');
         cOrder = colormap(cbrewer('qual','Paired',obj.numcases));
         markersize = 24;
         linewidth = 3;
         rect = [3 5 30 18];
         rect2 = [3 5 30 18];
         rect3 = [3 5 20 16];
         mkrs=['o';'d'];
         cOrdern=[1 2 3 4 5 2 3 4 5];
         linetypes={'-','-.'};
         n=1; % Number of iteration          
        FigH = figure('Position', get(0, 'Screensize'));
        
         for i=1:5:45
             
             if(i<=25)
                 Gtype=1;
             else
                 Gtype=2;
             end
             
             plot(rmax(i:i+4,:),'linestyle',linetypes{Gtype},'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth,'color',cOrder(cOrdern(n),:))
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','interpreter','latex','FontSize',32)
             ylabel('Coefficient Correlation','interpreter','latex','FontSize',32)
             set(gca,'Fontsize',fontsize)
             grid on;
             hold on
             
             n=n+1;
         end
         legend('fsDx10','fsDx25','fsDx50','fsDx75','fsDx100','SwDx25','SwDx50','SwDx75','SwDx100','interpreter','latex','Location','southwest','NumColumns',3,'FontSize',32);
         hold off
         
         
         
         %% Plot for Phase shift estimation
         figure()
         for i=1:5:25
             plot(Lag(:,i:i+4)*dt,'-o','LineWidth',3)
             xlim([0.5 5.75])
             xticks(1:5)
             xticklabels({'Co0.1','Co0.25','Co0.5','Co0.75','Co1'})
             xtickangle(45)
             xlabel('Courant Numbers','FontSize',32)
             ylabel('Phase shift(s)','FontSize',32)
             set(gca,'Fontsize',32)
             grid on;
             hold on
         end
         legend('Dx10','Dx25','Dx50','Dx75','Dx100','FontSize',32);
         hold off
         
         %% Plotting the Time series between window for 35s to 15s
         
         figure()
         
         for i=1:25
             plot(data2(:,1),Eta_foamStar(:,i),'LineWidth',2)
             hold on;
             % xlim([35 45])
             ylabel('surface elevation [m]','FontSize',32)
             xlabel('Time [s]','FontSize',32)
             set(gca,'Fontsize',32)
             
             grid on;
         end
         % legend ('Dx100Co1','Dx100Co 0.75','Dx100Co 0.5','Dx100Co 0.25','Dx100Co 0.1','HOS','FontSize',32);
         hold off;
     
            
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
            ylabel('Force [N]','interpreter','latex','FontSize',32)
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
                   k
                    FileName=[SWENSE_Basename,num2str(k-obj.foamStarnumcases)];
                    
                end
                 
                 if (k>(obj.foamStarnumcases+obj.SWENSEnumcases))
                     
                     p=9;
                   
                    FileName=[SWENSE_Basename,num2str(k-obj.foamStarnumcases-obj.SWENSEnumcases+p)];
                    
                end
                 
                
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
                data=readtable(foamStarfullfile);
                whos data
                
                %Finding Indexes
                [strVal,start_idx]=min(abs(obj.nstart-data{:,1}));
                [endVal,end_idx]=min(abs(obj.nend-data{:,1}));
                
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
            
            function CrossCorrelationPressureCourantNumberStudy(obj)
            
                % Loading Experimental data
            load(obj.Exptlocation)

            PP_Expt=[pp2(obj.ExptIndices,2) pp2(obj.ExptIndices,2) pp3(obj.ExptIndices,2) pp4(obj.ExptIndices,2) pp5(obj.ExptIndices,2) pp6(obj.ExptIndices,2) pp7(obj.ExptIndices,2) pp8(obj.ExptIndices,2)];

            pl_time=pp2(obj.ExptIndices,1)-obj.cps;   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/DiffCo/foamStar3DCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/DiffCo/SWENSE3DCase');
            Basename=[foamStar_Basename SWENSE_Basename]
            for k=1:6
                FileName=[foamStar_Basename,num2str(k)];
                
                if (k>3)
                    FileName=[SWENSE_Basename,num2str(k-3)];
                    
                end
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
                data=readtable(foamStarfullfile);
                whos data
                
                %Finding Indexes
                [strVal,start_idx]=min(abs(obj.nstart-data{:,1}));
                [endVal,end_idx]=min(abs(obj.nend-data{:,1}));
                
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
   
           for kk=1:6
               foamStar_dt=foamStar_dtPP{:,kk};
               T_step(kk)=foamStar_dt(2)-foamStar_dt(1);
           end
           
           [Small_Value,Small_idx]=min(T_step);

           FigH = figure('Position', get(0, 'Screensize'));
   
        
          for i=2:8
              
            IExpt_yaxis=interp1(pl_time,PP_Expt(:,i),foamStar_dtPP{:,Small_idx},'cubic');
              
            for k=1:6
            
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
               mkrs=['o';'s']; 
               % fontsize = 18;
               cOrdern=[1 2 3 1 2 3];
               n=1; % Number of iteration
               MarkerFilling=rand(3,3);
               
               for k=1:6
                   
                   if(k<=3)
                       Gtype=1;
                       c=rand(1,3);
                   else
                       Gtype=2;
                       c=rand(3,1);
                   end
                   plot(obj.ccost(k),mean(Q4(:,k)),'MarkerEdgeColor','black','MarkerFaceColor',MarkerFilling(cOrdern(n),:),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(cOrdern(n),:))
                   set(gca,'fontsize',fontsize)
                   ylim1 = [10^(-0.01) 10^(0)];
                   ylim(ylim1)
                   xlim([10^2 10^6])
                   set(gca, 'YScale', 'log')
                   set(gca, 'XScale', 'log')
                   set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
                   ylabalis =sprintf('Cross Correlation  Coefficient');
                   ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
                   
                   xlabalis =sprintf('Computational cost (s)');
                   xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
                   hold on
                   n=n+1;
               end
               
               hold off
               legend('fsCo 0.72','fsCo 7','fs Co 0.38','SwCo 0.72','SwCo 7','SwCo 0.38','interpreter','latex','Location','southeast','NumColumns',2)
               legend('boxon')
               % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
               title(['Pressure Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
               % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
               %     fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/CrossCorrleationError/';
               %    saveas(FigH, fullfile(fname, ['PPmean ']), 'jpeg');
               
               
              
            end
         
            function CrossCorrelationSurfaceElevationCourantNumberStudy(obj)
            
                % Loading Experimental data
            load(obj.Exptlocation)
            
            PP_Expt=[wp5(obj.ExptIndices,2) wp6(obj.ExptIndices,2) wp7(obj.ExptIndices,2)];
            
            pl_time=pp2(obj.ExptIndices,1)-obj.cps;   %Added for checking full time series of experiment
            
            clear pp* wp*
            
            %% foamStar data 
            foamStar_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'foamStar/DiffCo/foamStar3DCase');
            SWENSE_Basename=fullfile(obj.foamStarSWENSE_rootFolder,'SWENSE/DiffCo/SWENSE3DCase');
            Basename=[foamStar_Basename SWENSE_Basename]
            for k=1:6
                FileName=[foamStar_Basename,num2str(k)];
                
                if (k>3)
                    FileName=[SWENSE_Basename,num2str(k-3)];
                    
                end
                    
                foamStarfullfile=fullfile(FileName,'postProcessing/waveProbe/0/surfaceElevation.dat')
                data=readtable(foamStarfullfile);
                whos data
                
                %Finding Indexes
                [strVal,start_idx]=min(abs(obj.nstart-data{:,1}));
                [endVal,end_idx]=min(abs(obj.nend-data{:,1}));
                
                % foamStarPP_interp=interp1(foamStar_dtPP(:,k),foamStar_PP(:,i,k),foamStar_dtPP(:,Small_idx),'cubic');
                
                foamStar_dtPP{:,k}=data{start_idx:end_idx,1}+37; % 37 is the starting time in all cases(Hope so)
                PP_foamStar=data{start_idx:end_idx,2:end};
                
                
                for pp=1:3
                    foamStar_PP{:,pp,k} = PP_foamStar(:,pp);
                    
                end
                
                clear FileName data start_idx end_idx PP_foamStar 
            end
            
            
            %% Using Cross Correlation
   %% Finding the Interpolation time series
   
           for kk=1:6
               foamStar_dt=foamStar_dtPP{:,kk};
               T_step(kk)=foamStar_dt(2)-foamStar_dt(1);
           end
           
           [Small_Value,Small_idx]=min(T_step);

           FigH = figure('Position', get(0, 'Screensize'));
   
        
          for i=1:3
              
            IExpt_yaxis=interp1(pl_time,PP_Expt(:,i),foamStar_dtPP{:,Small_idx},'cubic');
              
            for k=1:6
            
                IP_Timeseries(:,k)=interp1(foamStar_dtPP{:,k},foamStar_PP{1,i,k},foamStar_dtPP{:,Small_idx},'cubic');
                
                %% Estimation single value in the Cross Correlation in Experiment
                [r(:,k),lags(:,k)]=xcorr(IP_Timeseries(:,k),IExpt_yaxis,'coeff');
                [~,I(:,k)]=max(abs(r(:,k)));
                Lag(:,k)=lags(I(:,k));
                Q4(i,k)=max(abs(r(:,k)));
                
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
               mkrs=['o';'s']; 
               % fontsize = 18;
               cOrdern=[1 2 3 1 2 3];
               n=1; % Number of iteration
               MarkerFilling=rand(3,3);
               
               for k=1:6
                   
                   if(k<=3)
                       Gtype=1;
                       c=rand(1,3);
                   else
                       Gtype=2;
                       c=rand(3,1);
                   end
                   plot(obj.ccost(k),mean(Q4(:,k)),'MarkerEdgeColor','black','MarkerFaceColor',MarkerFilling(cOrdern(n),:),'Marker',mkrs(Gtype),'MarkerSize',markersize,'linewidth',linewidth-1,'color',cOrder(cOrdern(n),:))
                   set(gca,'fontsize',fontsize)
                   ylim1 = [10^(-0.01) 10^(0)];
                   ylim(ylim1)
                   xlim([10^2 10^6])
                   set(gca, 'YScale', 'log')
                   set(gca, 'XScale', 'log')
                   set(gca,'xgrid','on','ygrid','on','gridlinestyle','-')
                   ylabalis =sprintf('Cross Correlation  Coefficient');
                   ylabel(ylabalis,'fontsize',fontsize,'interpreter','latex')
                   
                   xlabalis =sprintf('Computational cost (s)');
                   xlabel(xlabalis,'fontsize',fontsize,'interpreter','latex')
                   hold on
                   n=n+1;
               end
               
               yline(0.99, 'r--','HOS','LabelHorizontalAlignment','left','LineWidth', 4,'fontsize',32');
               % text(:,0.995,'Hi this is the line');
               
               hold off
               legend('fsCo 0.72','fsCo 7','fs Co 0.38','SwCo 0.72','SwCo 7','SwCo 0.38','interpreter','latex','Location','northeast','NumColumns',2)
               legend('boxon')
               % text(2400,0.016,'\textbf{foamStar }','Color','black','fontsize',fontsize+3,'interpreter','latex')
               title(['Wave Probe -MeanError Vs Computational Cost' ],'fontsize',fontsize,'interpreter','latex')
               % saveas(gcf,fullfile(graphFolder,sprintf('Efficiency_foamStar_space_%d_%s.png',fi,num2str(timeindex))))
               %     fname = '/home/saliyar/ownCloud3/Documents/owncloud-My sharing folder/Error_figures/PressureError/CrossCorrleationError/';
               %    saveas(FigH, fullfile(fname, ['PPmean ']), 'jpeg');
               
               
              
            end
            
    
        
    end
    
    
    
    
end