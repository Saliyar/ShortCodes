addpath lib/wave_spreading
type = 'cosn';
%% single test value
% Compare directional spreading and ocean like angular distribution
theta_0 = 0;
N_theta = 500;
u       = rand(1,N_theta);
switch type
    case 'cos2s'
        s = 25;
        norm = int_cos_2s(pi, s, theta_0);
        theta_range = [-pi, 2*pi];
    case 'cosn'
        n = 10;
        s = n;
        norm = int_cos_n(pi/2, n, theta_0);
        theta_range = [-pi/2, pi];
end
theta_test = theta_range(1) + theta_range(2) * (0:N_theta-1) / (N_theta-1);
for n=1:N_theta
    theta(n) = solve_inv_cum(type, u(n), s, theta_0, norm);
end
figure(1), clf
plot(theta, D(theta, s, theta_0, type) / norm,'o')
hold on
plot(theta_test, D(theta_test, s, theta_0, type)/ norm)
hold off

%% find Full Width at Half Maximum
switch type
    case 'cos2s'
        s_array = [10, 20, 25, 30, 40, 50];
%         s_array = [15, 25, 60];
    case 'cosn'
        n_array = [5, 10, 15];
        s_array = n_array;
end
figure(2), clf, hold all
width = [];
pks = [];
handle = [];
locs = [];
for n=1:length(s_array)
    s = s_array(n);
    switch type
        case 'cos2s'
            norm = int_cos_2s(pi, s, theta_0);
        case 'cosn'
            norm = int_cos_n(pi/2, s, theta_0);
    end
    D_test = D(theta_test, s, theta_0, type)/ norm;
    plot_handle(n) = plot(theta_test, D_test);
    [pks_local,locs_local,width_local] = findpeaks(D_test,theta_test,'WidthReference','halfheight');
    pks = [pks, pks_local];
    locs = [locs, locs_local];
    width = [width, width_local];
end
legend(num2str(s_array.'))
xlim([-1,1]*pi/2)
xlabel('Direction \theta (rad)')
ylabel('Spreading D(\theta)')
hold on
for n=1:length(width)
    plot(locs(n)+width(n)*[1,1]/2, pks(n)/2*[0,1], '--', 'Color', get(plot_handle(n), 'Color'))
    plot(locs(n)-width(n)*[1,1]/2, pks(n)/2*[0,1], '--', 'Color', get(plot_handle(n), 'Color'))
    plot(locs(n)+width(n)*[-1,1]/2, pks(n)/2*[1,1], '--', 'Color', get(plot_handle(n), 'Color'))
end
grid on
width * 180 / 3.14
    

% return
% 
% s_array = 2:100;
% width_array = zeros(length(s_array), 2);
% for n = 1:length(s_array)
%     s = s_array(n);
%     D_test = D(theta_test, s, theta_0, 'cos2s');
%     [pks_local,locs_local,width_local] = findpeaks(D_test,theta_test,'WidthReference','halfheight');
%     width_array(n,1) = width_local;
% %     width_array(n,1) = fwhm(theta_test, D_test);
%     D_test = D(theta_test, s, theta_0, 'coss');
%     [pks_local,locs_local,width_local] = findpeaks(D_test,theta_test,'WidthReference','halfheight');
%     width_array(n,2) = width_local;
% %     width_array(n,2) = fwhm(theta_test, D_test);
% end
% figure(3), clf
% plot(s_array, width_array(:,1) * 180/pi, s_array, width_array(:,2) * 180/pi)
% 
% % 
% figure(4), clf, hold all
% s = 40;
% D_test = D(theta_test, s, theta_0, 'cos2s');
%     plot(theta_test, D_test)
% D_test = D(theta_test, s/2, theta_0, 'coss');
%     plot(theta_test, D_test)
