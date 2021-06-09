function a_bound = calc_a_Stokes(alpha_0, omega, A_bound)
% a_bound = calc_a_Stokes
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_A_STOKES evaluates the second order
% bound wave amplitude
% Inputs
% alpha_0   progressive wavenumber
% omega     pulsation
% A_bound   second order bound potential amplitude
%  (see also the pdf file potential.pdf on the second order potential theory)
%
D_00 = (3 * omega^4 - alpha_0.' * alpha_0);
%
a_bound  = A_bound + D_00 ./ (4*omega^2);