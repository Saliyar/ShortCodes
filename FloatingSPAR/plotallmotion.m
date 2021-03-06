function plotallmotion(SPAR_Postprocessing_foamStar,titl,ylbl,nStart,nEnd,lgd1)

n=0;

for j=nStart:nEnd
   n=n+1;
    SPAR_Postprocessing=[SPAR_Postprocessing_foamStar,num2str(j)];
    foamStarfullfile=fullfile(SPAR_Postprocessing,'/postProcessing/motionInfo/0/cylinder1.dat');
    data=readtable(foamStarfullfile); 
    dt_motion{:,n}=data{:,1}
    pp=data{:,2:end};
    motion_foamStar(:,:,n)=pp;
end


%% Plotting motions
FigH = figure('Position', get(0, 'Screensize'));
for i=1:6
   
    clear n
    n=0;
for j=nStart:nEnd   
    
    n=n+1;
    dof6=motion_foamStar(:,i,n); 
    
    if (any(i>=4) && any(i<=6))
        dof6=dof6.*pi/180;   
    end
    
    if i>3
     if (i==4)
         
             FigH = figure('Position', get(0, 'Screensize'));
         
     end
         
        jj=i-3;
        plotmotion(jj,n,dt_motion,dof6,ylbl,titl,i)
    else
        jj=i;
        
         plotmotion(jj,n,dt_motion,dof6,ylbl,titl,i)
    end
    
end
saveas(FigH, [titl{:,i}],'png');
end

    function plotmotion(jj,n,dt_motion,dof6,ylbl,titl,i)
    subplot(3,1,jj)
    plot(dt_motion{:,n},dof6,'LineWidth',3)
    % xlim([0.05 20])
    ylabel(ylbl{:,i},'interpreter','latex','FontSize',20)
    xlabel('Time [s]','FontSize',20)
    set(gca,'Fontsize',20)
    title (titl{:,i},'interpreter','latex','FontSize',20);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    % legend (lgd1{:},'interpreter','latex','FontSize',32,'Location','southwest');
    grid on;
    hold on
  