function plotWavePacket(time,eta_lin,N_repeat,T_repeat, envelope, freq,ampli)
fontsize = 12;
figure(10+1), clf
subplot(3,1,1), plot(time, eta_lin(1:N_repeat,1)), drawnow
hold all
plot(time, abs(envelope))
set(gca, 'ColorOrderIndex', 2)
plot(time, -abs(envelope))
xlim([0,T_repeat])
SARAH_finish_plot(fontsize, 'Time (s)', 'Wave (m)')
bx(1) = subplot(3,2,[3,5]); plot(freq, abs(ampli)), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Amplitude (m)')
bx(2) = subplot(3,2,[4,6]); plot(freq, angle(ampli)), SARAH_finish_plot(fontsize, 'Frequency (Hz)', 'Phase (rad)')
linkaxes(bx,'x')
subplot(3,2,[4,6]), xlim([0,2])
figure(100), 
plot(time, eta_lin(1:N_repeat))
plot(time, abs(envelope))
set(gca, 'ColorOrderIndex', 2)
plot(time, -abs(envelope))
xlim([0,T_repeat])
SARAH_finish_plot(fontsize, 'Time (s)', 'Wave (m)')