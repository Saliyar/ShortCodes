function test_calc_I_n
% I_n = calc_I_n(mu_n, k, Ly, theta)
%
k  = 1;
Ly = 2 * pi;
mu_n = (0:1) * pi / Ly;
% positive theta
% theta = pi/6-0.001:0.00001:pi/6;
% theta = [theta 2*pi/6-fliplr(theta)];
% negative theta
theta = -pi/6-0.001:0.00001:-pi/6;
theta = [theta -2*pi/6-fliplr(theta)];
figure(1),clf,hold on
for m = 1:length(theta)
    n = length(mu_n);
    tmp = repmat([1 -1], 1, floor(n/2.0));
    if rem(n,2) == 1
        tmp(n) = 1;
    end
    test = 0;
    if theta(m) == 0.0
        I_n    = zeros(1, n);
        I_n(1) = 1.0;
    else
        sinth   = sin(theta(m));
        iksinth = i * k * sinth;
        N = length(mu_n);
        for n=1:N
            if mu_n(n) == abs(iksinth)
                I_n(n) = 1.0;
            elseif abs(abs(iksinth) - mu_n(n)) < 1.0e-4
                test=1;
                if mu_n(n) == 0
                    eps    = k * sinth * Ly;
                    I_n(n) = 1 - i * eps / 2 - eps^2 / 6;
                else
                eps    = (abs(k * sinth) - mu_n(n)) * Ly;
                beta   = mu_n(n) * Ly;
                gamma  = sign(k * sinth);
                I_n(n) = 1 + eps / (2 * beta) * (1 - i * gamma * beta) - ...
                             eps^2 / (2 * beta)^2 * (1 + i * gamma * beta + 2 / 3 * beta^2);
                end
            else
%                 if n == 2
%                     tempo = [(abs(iksinth)^2 - mu_n(n).^2) (tmp(n) * exp(-iksinth * Ly) - 1.0)]
%                 end
                I_n(n) = 2.0  / Ly * iksinth ./ (abs(iksinth)^2 - mu_n(n).^2) .* (tmp(n) * exp(-iksinth * Ly) - 1.0);
                if mu_n(n) == 0.0
                    I_n(n) = I_n(n) * 0.5;
                end
            end
        end
    end
    plot(theta(m),real(I_n(1)),'bs')
    plot(theta(m),imag(I_n(1)),'gs')
    if test == 0
        plot(theta(m),real(I_n(2)),'bo')
        plot(theta(m),imag(I_n(2)),'go')
    else
        plot(theta(m),real(I_n(2)),'rd')
        plot(theta(m),imag(I_n(2)),'rd')
    end    
end
ylim([-10 10])