function LHEEA_check_wavemaker(wv, fig)
if nargin < 2
    fig = 20;
end
%
time = 0:1/get(wv, 'f_samp'):get(wv, 'T_repeat');
wmk = get(wv, 'wmk');
if get(wmk, 'depth') >= 4.5 % main wave basin at LHEEA
    direction = get(wv, 'direction');
    theta_max = 0.3; % rad
    X_max = theta_max * (5-2.15);
     V_max = 1.0; % m/s % Put right value !!!!!
    
    if all(direction == 0)
        warning('off', 'convert2nondim:allready')
        [X, dot_X] = eval_X(wv, time, get(wv, 'type'));
        figure(fig), clf
        ax(1) = subplot(2,1,1);
        plot(time, X)
        ylabel('Position (m)')
        add_horizontal(X_max * [-1,1], 'r');
        ax(2) = subplot(2,1,2);
        plot(time, dot_X)
        ylabel('Velocity (m/s)')
        add_horizontal(V_max * [-1,1], 'r');
        xlabel('Time (s)')
        linkaxes(ax, 'x')
    else
        wv = set(wv, 'control_law', control_law(1:48, get(wv, 'law'), get(wv,'parameters')));
        X = eval_X_3D(wv, time).';
        figure(fig), clf
        for n=1:5
            subplot(5,1,n)
            ind = ((n-1)*10+1):min(size(X,2),10*n);
            plot(time, X(:,ind))
            ylabel('Position (m)')
            legend(num2str(ind.'))
            add_horizontal(X_max*[-1,1]);
        end
        xlabel('Time (s)')
    end
elseif get(wmk, 'depth') >= 1.5 % towing tank at LHEEA
    X_max = 0.4;
    V_max = 0.6; % m/s
%     warning('off', 'convert2nondim:allready')
    [X, dot_X] = eval_X(wv, time, get(wv, 'type'));
    figure(fig), clf
    ax(1) = subplot(2,1,1);
    plot(time, X)
    ylabel('Position (m)')
    if any(X >= 0.7*X_max)
        add_horizontal(X_max * [-1,1], 'r');
    end
    ax(2) = subplot(2,1,2);
    plot(time, dot_X)
    ylabel('Velocity (m/s)')
    if any(dot_X >= 0.7*V_max)
        add_horizontal(V_max * [-1,1], 'r');
    end
    xlabel('Time (s)')
    linkaxes(ax, 'x')
end