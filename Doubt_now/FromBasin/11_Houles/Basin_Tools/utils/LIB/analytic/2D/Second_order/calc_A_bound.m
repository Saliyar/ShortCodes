function A_bound = calc_A_bound(alpha_0, omega)
% A_bound = calc_A_bound
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_A_BOUND evaluates the second order
% progressive bound potential amplitude
% Inputs
% alpha_0 progressive wavenumbers
% omega   pulsation
%  (see also the pdf file potential.pdf on the second order potential theory)
%
D_00 = 6 * omega^4 - (alpha_0 + alpha_0)^2 - 2 * alpha_0 * alpha_0;
D_00 = D_00 ./ omega^2 ./  (-4 + (alpha_0 + alpha_0) * (alpha_0 + alpha_0) ./ (alpha_0 * alpha_0 + omega^4));
%
A_bound  = D_00 ./ 2;