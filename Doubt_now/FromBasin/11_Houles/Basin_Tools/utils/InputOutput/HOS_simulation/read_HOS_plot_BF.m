load a_3d
time = 0:1/f_samp:T_stop;
N = [50, 39, 61];
Np = [61, 72, 83, 94, 105, 116];
Nm = [39, 28, 17, 6];
k = 2*pi/xlen*N;
T = 2*pi./sqrt(9.81*k);
a = a_eta(N(1)+1,1,1);
figure(1), clf
% subplot(2,1,1)
plot(time/T(1), squeeze(a_eta(N+1,1,:))/a)
ylabel('a/a_0')
legend('0', '1-', '1+')
xlabel('t/T')
figure(2), clf
% subplot(2,1,2)
plot(time/T(1), squeeze(a_eta(Nm+1,1,:))/a, '-')
hold on
set(gca, 'ColorOrderIndex', 1)
plot(time/T(1), squeeze(a_eta(Np+1,1,:))/a, '--')
ylabel('a/a_0')
legend('1-', '2-', '3-', '4-', '1+', '2+', '3+', '4+', '5+', '6+')
hold off
xlabel('t/T')

