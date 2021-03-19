function plotanycase_6DOFmotion(Filelocation,titl,ylbl_deg,lgd1)

    File=[Filelocation];
    foamStarfullfile=fullfile(File,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion=data{:,1};
    pp_linear=data{:,2:4};
    pp_rotation=data{:,5:7};



%% Plotting motions
FigH = figure('Position', get(0, 'Screensize'));
newYlabels = {'Surge(m)','Sway(m)','Heave(m)'};
s=stackedplot(dt_motion, pp_linear,'DisplayLabels' , newYlabels);
s.LineWidth = 2;
s.XLabel={'Time [s]'};
s.FontSize = 25; 
s.FontName='Arial';
grid on;

FigH = figure('Position', get(0, 'Screensize'));
newYlabels = {'Roll(deg)','Pitch(deg)','Yaw(deg)'};
s=stackedplot(dt_motion, pp_rotation,'DisplayLabels' , newYlabels);
s.LineWidth = 2;
s.XLabel={'Time [s]'};
s.FontSize = 25; 
s.FontName='Arial';
grid on;


end

%     function plotmotion(jj,dt_motion,dof6,ylbl_deg,titl,i)
%     subplot(3,1,jj)
%     plot(dt_motion,dof6,'LineWidth',3)
%     % xlim([0.05 20])
%     ylabel(ylbl_deg{:,i},'interpreter','latex','FontSize',20)
%     xlabel('Time [s]','interpreter','latex', 'FontSize',20)
%     set(gca,'Fontsize',24)
%     title (titl{:,i},'interpreter','latex','FontSize',28);
%     % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
%     % legend (lgd1{:},'interpreter','latex','FontSize',32,'Location','southwest');
%     grid on;
%     hold on
%     end