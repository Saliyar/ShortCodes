%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function AnsysAQWAresults(za)
AQWA_freq=[0.033 0.121 0.209 0.297 0.385 0.473 0.561 0.648 0.736 0.824 0.912 1];
AQWA_AddedMass=[29.399 29.286829 29.429087 29.917038 30.536644 30.617769 30.01174 29.003855 27.946465 27.063633 26.435888 26.019785];
AQWA_RadiationDamping=[3.8095e-2 9.4687e-2 3.0735e-2 0.1232956 1.7080098 5.4848781 10.201213 14.216988 16.549906 17.057722 16.090014 13.998361];



omega_freq=2*pi.*AQWA_freq;
AQWA_AddedMassAmplified=AQWA_AddedMass;


figure()

subplot(2,1,1)
plot(omega_freq,AQWA_AddedMassAmplified,'LineWidth',3)
xlabel('Omega (rad/s)','interpreter','latex')
ylabel('Added Mass (kg)','interpreter','latex')
title('AQWA- Added Mass Vs Frequency','interpreter','latex')
grid on;
set(gca,'Fontsize',20)

subplot(2,1,2)
plot(omega_freq,AQWA_RadiationDamping,'LineWidth',3)
xlabel('Omega (rad/s)','interpreter','latex')
ylabel('Radiation Damping (N/(m/s))','interpreter','latex')
title('AQWA- Radiation damping Vs Frequency','interpreter','latex')
grid on;
set(gca,'Fontsize',20)

