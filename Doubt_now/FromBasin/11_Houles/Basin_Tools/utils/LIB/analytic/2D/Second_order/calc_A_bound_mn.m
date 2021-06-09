function A_bound_mn = calc_A_bound_mn(alpha_n, TF_n, omega)
% A_bound_mn = calc_A_bound_mn
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_A_BOUND_MN evaluates the second order
% bound potential amplitudes
% Inputs
% alpha_n progressive and evansecent wavenumbers
% TF_n    progressive and evansecent transfer function (a_n/a)
% omega   pulsation
%  (see also the pdf file potential.pdf on the second order potential theory)
%

% checking
alpha_n = make_it_row(alpha_n);
TF_n    = make_it_row(sum(make_it_column(TF_n),2));
%
alpha_mat = ones(size(alpha_n)).' * alpha_n;
alpha_npm = alpha_mat + alpha_mat.';
alpha_nmm = alpha_mat - alpha_mat.';
alpha_ntm = alpha_n.' * alpha_n;
%
D_mn = 6 * omega^4 - alpha_npm.^2 - 2 * alpha_ntm;
D_mn = - D_mn ./ (4*omega^4 - alpha_nmm.^2);
D_mn = D_mn .* (alpha_ntm + omega^4) ./ omega^2;
%
A_bound_mn  = D_mn .* ( TF_n.' * TF_n ) / 2;