function BargeMotionComparision2D(Filelocation,titl,ylbl_deg,lgd1)


    foamStarfullfile=fullfile(Filelocation,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion=data{:,1};
    pp=data{:,2:end};
    motion_foamStar=pp;
    
    dof6=pp(:,5);


%% Vineesh Roll / Pitch results 
Exptfile=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Vineesh_testcase/VineeshDatas','Roll Drecay Experiment.xlsx');
Expt_T1=xlsread(Exptfile,1,'a3:a2210');
Expt_Pitch=xlsread(Exptfile,1,'c3:c2210');

dof6=dof6+Expt_Pitch(1);
%% Plotting motions
FigH = figure('Position', get(0, 'Screensize'));

         plot(dt_motion,dof6,'LineWidth',3)
         hold on
         plot(Expt_T1,Expt_Pitch,'LineWidth',3)

    ylabel('Degree','interpreter','latex','FontSize',20)
    xlabel('Time [s]','FontSize',20)
    set(gca,'Fontsize',20)
    legend('foamStar-Pitch motion','Experiment-Pitch motion','interpreter','latex','FontSize',20)

    grid on;
    hold on
  