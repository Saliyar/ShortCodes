%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PPCD Error Percentage - Parametric study %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear 
clc
D_Spar=0.45;

%% Plot 1 : Surface Refinement Level Vs BlockMesh refinmeent 
load('PPCD_Errorxls.mat')

Xaxis=[0.5 0.4 0.3 0.2 0.1 0.05]/D_Spar;
for i=1:5
    for j=1:6
    Yaxis(j)=OVerall_Result(6*(i-1)+j,11);
    end
    plot(Xaxis,Yaxis,'-o','LineWidth',3)
    set (gca, 'xdir' , 'reverse' )
    ylabel('Error[%]','interpreter','latex','FontSize',32)
    xlabel('Background Mesh size $ (x/D_{SPAR})$','interpreter','latex','FontSize',32)
    % ylim([0 0.5])
    set(gca,'Fontsize',32)
    title ('Surface refinement','interpreter','latex','FontSize',32);
    legend ('Very coarse','Coarse','Medium','Fine','Very Fine','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    clear Yaxis
    
end

%% Plot 1 : Surface Refinement Level Vs BlockMesh refinmeent 
% load('PPCD_Errorxls.mat')
% figure()
% 
% Xaxis=[0.5 0.4 0.3 0.2 0.1 0.05];
% for i=1:5
%     for j=1:6
%         Xaxis(j) = OVerall_Result(6*(i-1)+j,8);  
%     Yaxis(j)=OVerall_Result(6*(i-1)+j,11);
%     end
%     plot(Xaxis,Yaxis,'LineWidth',3)
%     set (gca, 'xdir' , 'reverse' )
%     ylabel('Error[%]','interpreter','latex','FontSize',32)
%     xlabel('NUmber of cells','interpreter','latex','FontSize',32)
%     % ylim([0 0.5])
%     set(gca,'Fontsize',32)
%     title ('Surface refinement','interpreter','latex','FontSize',32);
%     legend ('Very coarse','Coarse','Medium','Fine','Very Fine','interpreter','latex','FontSize',32,'Location','northeast');
%     grid on
%     hold on
%     clear Yaxis
%     
% end



figure()
for i=3:5
    for j=1:6
    Yaxis(j)=OVerall_Result(6*(i-1)+j,11);
    end
    plot(Xaxis,Yaxis,'-o','LineWidth',3)
    set (gca, 'xdir' , 'reverse' )
    ylabel('Error[%]','interpreter','latex','FontSize',32)
     xlabel('Background Mesh size $ (x/D_{SPAR})$','interpreter','latex','FontSize',32)
    % ylim([0 0.5])
    set(gca,'Fontsize',32)
    title ('Surface refinement','interpreter','latex','FontSize',32);
    legend ('Medium','Fine','Very Fine','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    clear Yaxis
    
end


%% Plot of Number of Cells vs Error and accuracy 
titl={'Very coarse','Coarse','Medium','Fine','Very Fine'};

for i=1:5
   
    for j=1:6
    Xaxis1(j)=OVerall_Result(6*(i-1)+j,11);
    Yaxis(j)=OVerall_Result(6*(i-1)+j,8);
    end
    % subplot(3,2,i)
    FigH = figure('Position', get(0, 'Screensize'));
    bar(Xaxis1,Yaxis/(10^6))
    set (gca, 'xdir' , 'reverse' )
    ylabel('Number of cells (in million)','interpreter','latex','FontSize',40)
    xlabel('Error(\%)','interpreter','latex','FontSize',40)
    % ylim([0 0.5])
    set(gca,'Fontsize',40)
    title (titl(i),'interpreter','latex','FontSize',40);
    % legend ('Level 3','Level 4','Level 5','interpreter','latex','FontSize',32,'Location','northeast');
    grid on
    hold on
    fpath='/home/saliyar/Thesis/Chapter4/Figures/Mesh/';
   saveas(FigH,fullfile(fpath,titl{:,i}),'eps');
    
end


    ppcd = [10 25 35 50 75];
    Error=[0.35 0.18 0.1 0.06 0.04];
    FigH = figure('Position', get(0, 'Screensize'));
    
    plot(ppcd,Error,'-o','LineWidth',4,'MarkerSize',10)
    ylabel('Error ($\%$)','interpreter','latex','FontWeight', 'bold','FontSize',30)
    xlabel('P.P.S.D(Points per Spar diameter)','interpreter','latex','FontSize',30)
    ax=gca;
    ax.XTick=10:20:80;
    ax.YTick=0.05:0.1:0.35;
    set(ax,'XTickLabelRotation',45)
    set(gca,'Fontsize',30)
    grid on
    title ('Mesh sensitivity','interpreter','latex','FontSize',32);