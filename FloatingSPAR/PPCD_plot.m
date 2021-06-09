%%% PPCD plot

close all
clear 
clc

    ppcd = [10 25 35 50 75];
    Error=[0.35 0.18 0.1 0.06 0.04];
    FigH = figure('Position', get(0, 'Screensize'));
    
    plot(ppcd,Error,'-o','LineWidth',3,'MarkerSize',10)
    ylabel('Error ($\%$)','interpreter','latex','FontWeight', 'bold','FontSize',30)
    xlabel('P.P.S.D(Points per Spar diameter)','interpreter','latex','FontSize',30)
    ax=gca;
    ax.XTick=10:20:80;
    ax.YTick=0.05:0.1:0.35;
    set(ax,'XTickLabelRotation',45)
    set(gca,'Fontsize',30)
    grid on
    title ('Mesh sensitivity','interpreter','latex','FontSize',32);
    
    % legend('foamStar-Pitch motion','Experiment-Pitch motion','interpreter','latex','FontSize',20)