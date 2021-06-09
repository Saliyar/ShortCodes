function I_n = calc_I_n(mu_n, k, Ly, theta, type, N_flaps, n_cur)
% I_n = calc_I_n(mu_n, k, Ly, theta)
% or I_n = calc_I_n(mu_n, k, Ly, theta, type, N_flaps, n_cur)
%
N = length(mu_n);
tmp = repmat([1 -1], 1, floor(N/2.0)); % this vector stores (-1)^n
if rem(N,2) == 1
    tmp(N) = 1;
end
% Check the number of arguments, if lower than 4, this has to be a
% continuous wavemaker
if nargin <= 4
    type = 'continuous';
end
%
switch type
    case 'single_flap'
        I_n(1)   = 1.0 / real(N_flaps);
        B        = Ly  / real(N_flaps);
        I_n(2:N) = 2.0 ./ (mu_n(2:N) * Ly) .* (sin(real(n_cur) * mu_n(2:N) * B) - sin(real(n_cur-1) * mu_n(2:N) * B));
    case 'restricted'
        X_d = N_flaps(1);
        y_d = N_flaps(2);
        y_f = N_flaps(3);
        % \frac{2}{L_y(1+\delta_ {0n}} \frac{\cos(\mu_n y_f) - \cos(\mu_n y_d)}{\mu_n^2 (y_f-y_d)}
        I_n = zeros(1, N);
        for n=1:N
            I_n(n) = 1/Ly;
            if mu_n(n) == 0.0
                if y_d < y_f
                    I_n(n) = I_n(n) * (Ly-y_f+(y_f-y_d)/2);
                else
                    I_n(n) = I_n(n) * (y_f+(y_d-y_f)/2);
                end
            else
                I_n(n) = I_n(n) * 2 * (cos(mu_n(n)*y_f) - cos(mu_n(n)*y_d)) / (mu_n(n)^2*(y_f-y_d));
                if y_d >= y_f
                    I_n(n) = - I_n(n);
                end
            end
        end
    case 'continuous'
        I_n = zeros(1, N);
        if theta == 0
            I_n(1) = 1.0;
        else
            sinth   = sin(theta);
            iksinth = 1i * k .* sinth;
            for n=1:N
                if mu_n(n) == abs(iksinth)
                    I_n(n) = 1.0;
                elseif abs(abs(iksinth) - mu_n(n)) < 1.0e-4
                    if mu_n(n) == 0
                        eps    = k .* sinth * Ly;
                        I_n(n) = 1 - 1i * eps / 2 - eps.^2 / 6;
                    else
                        eps    = (abs(k .* sinth) - mu_n(n)) * Ly;
                        beta   = mu_n(n) * Ly;
                        gamma  = sign(k .* sinth);
                        I_n(n) = 1 + eps / (2 * beta) .* (1 - 1i * gamma * beta) - ...
                            eps.^2 / (2 * beta)^2 .* (1 + 1i * gamma * beta + 2 / 3 * beta^2);
                    end
                else
                    I_n(n) = 2.0  / Ly * iksinth ./ (abs(iksinth).^2 - mu_n(n).^2) .* (tmp(n) * exp(-iksinth * Ly) - 1.0);
                    if mu_n(n) == 0.0
                        I_n(n) = I_n(n) * 0.5;
                    end
                end
            end
        end
end
