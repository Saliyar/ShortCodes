%% Code to check the Pressure probe results between foamStar and SWENSE
function Expt_CylMovement(Exptforcepath)

load(Exptforcepath)
Expt_time=Channel_1_Data;
Expt_CylinderMoment=Channel_11_Data;

% Converting volts to N in Experimental results using calibration constant
% Expt_force_N=Expt_force_volts*2455.5; % 2455.5 N/V

plot(Expt_time,Expt_CylinderMoment,'LineWidth',3);
ylabel('Speed m/s','FontSize',32)
xlabel('Time [s]','FontSize',32)
set(gca,'Fontsize',32)
title('Cylinder movement with acceleration' ,'FontSize',32)
% legend ('foamStar','Experiment','FontSize',32);
grid on;