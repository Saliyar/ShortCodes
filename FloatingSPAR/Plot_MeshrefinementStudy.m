%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PPCD Error Percentage - Parametric study %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear 
clc
%% Plot 1 : Surface Refinement Level Vs BlockMesh refinmeent 
load('PPCD_Errorxls.mat')

Xaxis=[0.5 0.4 0.3 0.2 0.1 0.05];
for i=1:5
    for j=1:6
    Yaxis(j)=OVerall_Result(6*(i-1)+j,11);
    end
    plot(Xaxis,Yaxis,'LineWidth',3)
    set (gca, 'xdir' , 'reverse' )
    ylabel('Error[%]','FontSize',32)
    xlabel('BlockMesh cell size(m)','interpreter','latex','FontSize',32)
    % ylim([0 0.5])
    set(gca,'Fontsize',32)
    title ('Mesh refinemnt Vs Surface refinement','interpreter','latex','FontSize',32);
    legend ('Level 1','Level 2','Level 3','Level 4','Level 5','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    clear Yaxis
    
end
figure()
for i=3:5
    for j=1:6
    Yaxis(j)=OVerall_Result(6*(i-1)+j,11);
    end
    plot(Xaxis,Yaxis,'LineWidth',3)
    set (gca, 'xdir' , 'reverse' )
    ylabel('Error[%]','FontSize',32)
    xlabel('BlockMesh cell size(m)','interpreter','latex','FontSize',32)
    % ylim([0 0.5])
    set(gca,'Fontsize',32)
    title ('Mesh refinemnt Vs Surface refinement','interpreter','latex','FontSize',32);
    legend ('Level 3','Level 4','Level 5','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    clear Yaxis
    
end


%% Plot of Number of Cells vs Error and accuracy 
titl={'Level 1','Level 2','Level 3','Level 4','Level 5'};
figure()
for i=1:5
    for j=1:6
    Xaxis1(j)=OVerall_Result(6*(i-1)+j,11);
    Yaxis(j)=OVerall_Result(6*(i-1)+j,8);
    end
    subplot(3,2,i)
    bar(Xaxis1,Yaxis)
    set (gca, 'xdir' , 'reverse' )
    ylabel('Number of cells','FontSize',12)
    xlabel('Error(%))','FontSize',12)
    % ylim([0 0.5])
    set(gca,'Fontsize',12)
    title (titl(i),'interpreter','latex','FontSize',15);
    % legend ('Level 3','Level 4','Level 5','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    
end