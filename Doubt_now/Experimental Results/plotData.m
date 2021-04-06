clc
close all

clear all
load('catA_23003.mat')

%% WM

figure(5)
subplot(2,2,1)
pl=wm;
plot(pl(:,1),pl(:,2))
xlabel('Time [s]','FontSize',15)
ylabel('Displacement [m]','FontSize',15)
title('Wavemaker Displacement','FontSize',15)

subplot(2,2,2)
pl=sp;
plot(pl(:,1),pl(:,2))
ylabel('Speed [m/s]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('Cylinder Speed Towards Wave-maker','FontSize',15)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



%% WP

figure(4)
subplot(2,2,1)
pl=wp5;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP5','FontSize',15)

subplot(2,2,2)
pl=wp6;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP6','FontSize',15)

subplot(2,2,3)
pl=wp7;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP7','FontSize',15)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



figure(3)
subplot(2,2,1)
pl=wp1;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP1','FontSize',15)

subplot(2,2,2)
pl=wp2;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP2','FontSize',15)

subplot(2,2,3)
pl=wp3;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP3','FontSize',15)

subplot(2,2,4)
pl=wp4;
plot(pl(:,1),pl(:,2))
ylabel('Elevation [m]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('WP4','FontSize',15)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



%% PP

figure(2)
subplot(2,2,1)
pl=pp6;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP6','FontSize',15)

subplot(2,2,2)
pl=pp7;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP7','FontSize',15)

subplot(2,2,3)
pl=pp8;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP8','FontSize',15)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);



figure(1)
subplot(2,2,1)
pl=pp2;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP2','FontSize',15)

subplot(2,2,2)
pl=pp3;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP3','FontSize',15)

subplot(2,2,3)
pl=pp4;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP4','FontSize',15)

subplot(2,2,4)
pl=pp5;
plot(pl(:,1),pl(:,2))
ylabel('Dynamic Pressure [mBar]','FontSize',15)
xlabel('Time [s]','FontSize',15)
title('PP5','FontSize',15)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);