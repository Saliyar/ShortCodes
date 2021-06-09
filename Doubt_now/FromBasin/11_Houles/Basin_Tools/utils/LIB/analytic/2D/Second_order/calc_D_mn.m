function D_mn = calc_D_mn(alpha_n, omega)
% D_mn = calc_D_mn(alpha_n, omega)
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_D_MN evaluates a term useful when 
% computing the second order free wave amplitudes
% Inputs
% alpha_n       progressive and evansecent wavenumbers
% omega         pulsation
%  (see also the pdf file potential.pdf on the second order potential theory)
%

% checking
alpha_n = make_it_row(alpha_n);
row_one = ones(size(alpha_n));
col_one = row_one.';
%
% wave_info = info('pulsation', 2*omega);
% beta      = get(wave_info,'wavenumber');
beta      = wave_number(2*omega / (2*pi));
alpha_mat = col_one*alpha_n;
alpha_npm = alpha_mat + alpha_mat.';
D_mn      = alpha_npm .* (5*omega^4 - col_one*(alpha_n.^2) - alpha_n.'*alpha_n - (alpha_n.^2).'*row_one) ./ (beta^2 - alpha_npm.^2);
% figure(2)
% terme complet
% subplot(1,2,1)
% surf(abs(5*omega^4 - col_one*(alpha_n.^2) - alpha_n.'*alpha_n - (alpha_n.^2).'*row_one))
% subplot(1,2,2)
% surf(angle(5*omega^4 - col_one*(alpha_n.^2) - alpha_n.'*alpha_n - (alpha_n.^2).'*row_one))
% le terme L_mn_12_plus seul
% subplot(1,2,1)
% surf(abs(2 .* 2*omega .* (omega^4 - alpha_n.'*alpha_n) + omega .* (omega^4 - (alpha_mat.^2).') + ...
%                          omega .* (omega^4 - alpha_mat.^2)))
% subplot(1,2,2)
% surf(angle(2 .* 2*omega .* (omega^4 - alpha_n.'*alpha_n) + omega .* (omega^4 - (alpha_mat.^2).') + ...
%                          omega .* (omega^4 - alpha_mat.^2)))
% le reste
% subplot(1,2,1)
% surf(abs(2*omega .* ( (2*omega)^2 .* (alpha_n.'*alpha_n + omega^4) - ...
%     alpha_npm .* (alpha_mat .* omega^2 + alpha_mat.' .* omega^2) )))
% subplot(1,2,2)
% surf(angle(2*omega .* ( (2*omega)^2 .* (alpha_n.'*alpha_n + omega^4) - ...
%     alpha_npm .* (alpha_mat .* omega^2 + alpha_mat.' .* omega^2) )))
% terme beta^2-(alpha_n+alpha_m)^2
% subplot(1,2,1)
% surf(abs(1 ./ (beta^2 - alpha_npm.^2)))
% subplot(1,2,2)
% surf(angle(1 ./ (beta^2 - alpha_npm.^2)))
