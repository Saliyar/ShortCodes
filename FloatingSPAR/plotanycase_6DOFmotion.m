function plotanycase_6DOFmotion(Filelocation,titl,ylbl_deg,lgd1)

    File=[Filelocation];
    foamStarfullfile=fullfile(File,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion=data{:,1};
    pp=data{:,2:end};
    motion_foamStar=pp;



%% Plotting motions
FigH = figure('Position', get(0, 'Screensize'));
for i=1:6
   
    dof6=motion_foamStar(:,i); 
    
    if i>3
     if (i==4)
         
             FigH = figure('Position', get(0, 'Screensize'));
         
     end
     if (i==5)
            dof6=dof6-8.36329947836836; %Initial amplitude for Vineesh case!! 
     end
         
        jj=i-3;
        plotmotion(jj,dt_motion,dof6,ylbl_deg,titl,i)
    else
        jj=i;
        
         plotmotion(jj,dt_motion,dof6,ylbl_deg,titl,i)
    end
    
end
saveas(FigH, [titl{:,i}],'png');
end

    function plotmotion(jj,dt_motion,dof6,ylbl_deg,titl,i)
    subplot(3,1,jj)
    plot(dt_motion,dof6,'LineWidth',3)
    % xlim([0.05 20])
    ylabel(ylbl_deg{:,i},'interpreter','latex','FontSize',20)
    xlabel('Time [s]','FontSize',20)
    set(gca,'Fontsize',20)
    title (titl{:,i},'interpreter','latex','FontSize',20);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    % legend (lgd1{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold on
    end