function a_mn_bound = calc_a_mn_bound(alpha_n, TF_n, omega, A_bound_mn)
% a_mn_bound = calc_a_mn_bound
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_A_MN_BOUND evaluates the second order
% bound wave amplitudes
% Inputs
% alpha_n       progressive and evansecent wavenumbers
% TF_n          progressive and evansecent transfer function (a_n/a)
% omega         pulsation
% A_bound_mn    second order bound potential amplitudes
%  (see also the pdf file potential.pdf on the second order potential theory)
%

% checking
alpha_n = make_it_row(alpha_n);
TF_n    = make_it_row(TF_n);
%
D_mn = (3 * omega^4 - alpha_n.' * alpha_n);
%
a_mn_bound  = A_bound_mn + D_mn .* ( (TF_n(1,:) + TF_n(2,:)).' * (TF_n(1,:) + TF_n(2,:)) ) / (4*omega^2);