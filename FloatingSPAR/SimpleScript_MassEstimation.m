%%%Sample Script to Estimate mass and added mass

clear
close all
clc
%% Input parameters
T_exp=4.85;
T_num=4.65;
D=0.28; % At water plane


Stiffness_rhogAw=1000*9.81*pi/4*D^2;
M=(2*pi*T_exp)^2*Stiffness_rhogAw;
n=0;

for i=0:10:100
    n=n+1;   
    mass(n)=300+i;
    T_check(n)=2*pi*sqrt(mass(n)/Stiffness_rhogAw);
end
%% Plot the Figures

FigH = figure('Position', get(0, 'Screensize'));
plot(mass,T_check,'LineWidth',3)
% xlim([0.05 40])
    ylabel('Time [s]','interpreter','latex','FontSize',32)
    xlabel('Mass(kg)','FontSize',32)
    set(gca,'Fontsize',32)
 title ('Mass Vs Time period','interpreter','latex','FontSize',32);
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
%legend (lgd8{:},'interpreter','latex','FontSize',32,'Location','southwest');
grid on;
hold off
saveas(FigH, 'MassVsTimePeriod','png');