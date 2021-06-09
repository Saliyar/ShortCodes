function N_1 = calc_N_1(k, L_y)
% N_1 = calc_N_1(k, L_y)
% LIB\ANALYTIC\3D\LINEAR\CALC_N_1 evaluates the number of the last
% progressive mode. Note that both inputs must have the same dimensional
% form.
% Inputs
%   k    wavenumber
%   L_y  width of the wave basin
%
N_1 = floor(k * L_y / pi);