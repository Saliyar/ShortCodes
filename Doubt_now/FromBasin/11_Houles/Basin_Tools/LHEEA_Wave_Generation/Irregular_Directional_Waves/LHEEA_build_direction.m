function direction = LHEEA_build_direction(display, harmo, theta_0, spreading, s, index)
% direction = LHEEA_build_direction(display, harmo, theta_0, s)
% build directional spreading from directional parameters,
% for cos^2s ((theta-theta_0)/2) or cos^n (theta-theta_0) spreadings
% Inputs
% display   #1 =0 no display, =1 plot the spectrum
% harmo     #2 vector of wave front harmonics
% theta_0   #3 wave heading (degrees)
% spreading #4 spreading distribution function (either cosn or cos2s)
% s         #5 spreading coefficient of the distribution function (either s or n).
% index     #6 index for the seed of the random number generator
% See the table below to know the relation between "s" or "n" and spreading width
% "s" parameter 10 20 30 40 50 for cos 2s
% FWHM (deg)    60 43 35 30 27
% "n" parameter 5  10 15 20 25 for cos n
% remember that cos^2s(theta/2) is equivalent to cos^n(theta) when n=s/2

global spreading_names
% FontSize for display
fs = 13;

%% Wave direction
switch spreading
    case spreading_names.uni
        % uni-directional waves
        direction = theta_0 * ones(size(harmo)); % uni-directional waves
    otherwise
        %% build directional spreading
        % converting input (degrees) into rad
        theta_0 = theta_0 * pi / 180;
        % number of wave components
        N_theta = length(harmo);
        % the random seed for each run
        rng(index + 1000, 'twister'); % specify the seed and the type of the random number generator
        % rand values between 0 and 1
        u    = rand(1,N_theta);
        switch spreading
            case spreading_names.cos_2n
                % evaluates the norm of cos^2s
                norm = int_cos_2s(pi, s, theta_0);
            case spreading_names.cos_n
                % evaluates the norm of cos^n
                norm = int_cos_n(pi/2, s, theta_0);
        end
        % picking wave direction with cos^2s or cos^n distribution
        theta = zeros(size(harmo));
        for n=1:N_theta
            theta(n) = solve_inv_cum(spreading, u(n), s, theta_0, norm);
        end
        % Output in degrees
        direction = theta * 180 / pi;
        %
        %% Display
        if display
            figure(2), clf
            plot(theta, D(theta, s, theta_0, spreading) / norm,'o')
            set(gca, 'FontSize', fs)
            hold on
            switch spreading
                case spreading_names.cos_2n
                    theta_range = [-pi, 2*pi];
                case spreading_names.cos_n
                    theta_range = [-pi/2, pi];
            end
            theta_test = theta_range(1) + theta_range(2) * (0:N_theta-1) / (N_theta-1);
            plot(theta_test, D(theta_test, s, theta_0, spreading)/ norm)
            hold off
            xlabel('Wave direction \theta (rad)')
            ylabel('D(\theta)')
            add_vertical(pi*[[-1,1]/2,[-1,1]/3,[-1,1]/4]);
        end
end