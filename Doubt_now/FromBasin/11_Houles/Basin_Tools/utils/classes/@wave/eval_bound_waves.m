function [w_p, w_m, k_p, k_m, ae_00_p, ae_00_m, Ae_00_p, Ae_00_m] = eval_bound_waves(wv_2D)
% eval_bound_waves(wv_2D)
% @WAVE\EVAL_BOUND_WAVES evaluates the progressive bound wave amplitude for the wave object
% Inputs:
%   wv_2D               is a wave object in 2D,
% Output:
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%

% Going to nondimensional form
depth = get(wv_2D, 'depth');
wv_2D = convert2nondim(wv_2D);
%
n_harmo = length(wv_2D); % = get(wv_2D,'n_harmo');
ampli   = get(wv_2D, 'ampli');
phase   = get(wv_2D, 'phase');
%
% temporary storage
omega = get(wv_2D,'pulsation');
alpha_n = wave_number(omega / (2 * pi)).';
h_wait = init_wait_time_bar('Evaluating TF_n and stuff');
% Keeping the same waitbar but reinitialising time and title
tic
wait_time_bar(h_wait, 1.e-4, ['n1 = ',num2str(1) ' over ' num2str(n_harmo)])
% Let's go to the big loop
w_p = zeros(n_harmo, n_harmo);
w_m = zeros(n_harmo, n_harmo);
k_p = zeros(n_harmo, n_harmo);
k_m = zeros(n_harmo, n_harmo);
ae_00_p = zeros(n_harmo, n_harmo);
ae_00_m = zeros(n_harmo, n_harmo);
Ae_00_p = zeros(n_harmo, n_harmo);
Ae_00_m = zeros(n_harmo, n_harmo);
warning('calc_Fm_pm(k1,k2) is evaluated as tanh(k1+pm*k2)')
% complex amplitudes
for n1=1:n_harmo
    % Useful
    a_1 = ampli(n1) .* exp(1i * phase(n1));
    k_1 = alpha_n(n1);
    for n2=1:n1-1 % off-diagonal terms
        % Sum term
        pm  = 1;
        a_2 = ampli(n2) .* exp(1i * phase(n2));
        a_2 = star(a_2,pm);
        k_2 = star(alpha_n(n2), pm);
        Fm_pm          = calc_Fm_pm(k_1, omega(n1), k_2, omega(n2), pm);
        Ae_00_pm       = calc_Ae_00_pm(a_1, a_2, omega(n1), omega(n2), k_1, k_2, Fm_pm, pm);
        %         Ae_00_pm       = 0.0;
        Ae_00_p(n1,n2) = Ae_00_pm;
        Ae_00_p(n2,n1) = Ae_00_p(n1,n2);
        ae_00_p(n1,n2) = calc_ae_00_pm(omega(n1), omega(n2), a_1, a_2, k_1, k_2, Ae_00_pm, pm);
        %         ae_00_p(n1,n2) = calc_ae_00_pm(omega(n1), omega(n2), 0, 0, k_1, k_2, Ae_00_pm, pm);
        ae_00_p(n2,n1) = ae_00_p(n1,n2);
        w_p(n1,n2) = omega(n1) + omega(n2);
        w_p(n2,n1) = w_p(n1,n2);
        k_p(n1,n2) = k_1 + k_2;
        k_p(n2,n1) = k_p(n1,n2);
        %
        % Difference term
        pm  = -1;
        a_2 = ampli(n2) .* exp(1i * phase(n2));
        a_2 = star(a_2,pm);
        k_2 = star(alpha_n(n2), pm);
        Fm_pm          = calc_Fm_pm(k_1, omega(n1), k_2, omega(n2), pm);
        Ae_00_pm       = calc_Ae_00_pm(a_1, a_2, omega(n1), omega(n2), k_1, k_2, Fm_pm, pm);
%         Ae_00_pm       = calc_Ae_00_pm(a_1, a_2, omega(n1), omega(n2), k_1, k_2, 0, pm);
%                 Ae_00_pm       = 0.0;
        Ae_00_m(n1,n2) = Ae_00_pm;
        Ae_00_m(n2,n1) = Ae_00_m(n1,n2);
        ae_00_m(n1,n2) = calc_ae_00_pm(omega(n1), omega(n2), a_1, a_2, k_1, k_2, Ae_00_pm, pm);
%                 ae_00_m(n1,n2) = calc_ae_00_pm(omega(n1), omega(n2), 0, 0, k_1, k_2, Ae_00_pm, pm);
        ae_00_m(n2,n1) = ae_00_m(n1,n2);
        w_m(n1,n2) = omega(n1) - omega(n2);
        w_m(n2,n1) = w_m(n1,n2);
        k_m(n1,n2) = k_1 - k_2;
        k_m(n2,n1) = k_m(n1,n2);
    end
    for n2=n1
        % Self term, auto-interaction, diagonal
        pm  = 1;
        a_2 = ampli(n2) .* exp(1i * phase(n2));
        a_2 = star(a_2,pm);
        k_2 = star(alpha_n(n2), pm);
        Fm_pm          = calc_Fm_pm(k_1, omega(n1), k_2, omega(n2), pm);
        Ae_00_pm       = calc_Ae_00_pm(a_1, a_2, omega(n1), omega(n2), k_1, k_2, Fm_pm, pm);
        %         Ae_00_pm       = 0.0;
        Ae_00_p(n1,n2) = Ae_00_pm;
        Ae_00_m(n1,n2) = 0;
        ae_00_p(n1,n2) = calc_ae_00_pm(omega(n1), omega(n2), a_1, a_2, k_1, k_2, Ae_00_pm, pm);
        ae_00_p(n1,n2) = ae_00_p(n1,n2) / 2; 
        w_p(n1,n2) = 2*omega(n1);
        w_m(n1,n2) = 0;
        k_p(n1,n2) = 2*k_1;
        k_m(n1,n2) = 0;
    end
    wait_time_bar(h_wait, n1/n_harmo, ['n1 = ',num2str(n1) ' over ' num2str(n_harmo)])
end
close(h_wait)
% figure(2)
% subplot(1,2,1)
% v = [-16 -8 -4 -2 -1 -0.5 0 0.5 1 2 4 8 16];
% [C,handle] = contour(omega, omega, abs(ae_00_m)*depth^2);
% set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
% title('Difference')
% xlabel('\omega_1')
% ylabel('\omega_2')
% subplot(1,2,2)
% [C,handle] = contour(omega, omega, abs(ae_00_p)*depth^2);
% set(handle,'ShowText','on','TextStep',get(handle,'LevelStep'))
% title('Sum')
% xlabel('\omega_1')
% ylabel('\omega_2')
%
if nargout > 0
    g = 9.81;
    Ae_00_p = Ae_00_p*sqrt(g*depth);
    Ae_00_m = Ae_00_m*sqrt(g*depth);
    ae_00_p = ae_00_p*depth;
    ae_00_m = ae_00_m*depth;
    k_p = k_p/depth;
    k_m = k_m/depth;
    w_p = w_p*sqrt(g/depth);
    w_m = w_m*sqrt(g/depth);
end
%
function Fm_pm = calc_Fm_pm(alpha_1, omega_1, alpha_2, omega_2, pm)
%
Fm_pm = tanh(alpha_1+pm*alpha_2); % (alpha_1 * omega_2^2 + pm * alpha_2 * omega_1^2) / (pm * alpha_1 * alpha_2 + (omega_2 * omega_1)^2);
%
function Ae_00_pm = calc_Ae_00_pm(a_1, a_2, omega_1, omega_2, alpha_1, alpha_2, Fm_pm, pm)
%
Ae_00_pm = a_1 * a_2 * ((omega_1 + pm * omega_2) / (omega_1 * omega_2) * (pm * (omega_1 * omega_2)^2 - alpha_1 * alpha_2) ...
    + (omega_1^4 - alpha_1^2) / (2 * omega_1) + pm * (omega_2^4 - alpha_2^2) / (2 * omega_2)) / ...
    (- (omega_1 + pm * omega_2)^2 + (alpha_1 + pm * alpha_2) * Fm_pm);
%
function ae_00_pm = calc_ae_00_pm(omega_1, omega_2, a_1, a_2, alpha_1, alpha_2, Ae_00_pm, pm)
%
ae_00_pm = (omega_1 + pm * omega_2) * Ae_00_pm + a_1 * a_2 / 2 * ((omega_1 + pm * omega_2)^2 ...
    - pm * omega_1 * omega_2 - alpha_1 * alpha_2 / (omega_1 * omega_2));

