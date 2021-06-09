function [U_prog, U_evan, V_prog, V_evan, W_prog, W_evan] = calc_UVW_lin(pot_3D, x, y, z, time)
% [U_prog, U_evan, V_prog, V_evan, W_prog, W_evan] = calc_UVW_lin(pot_3D, x, y, z, time)
% @POTENTIAL_3D\CALC_UVW_LIN evaluates the linear wave velocities at position x,y,z at time t for the potential_3D object
% Inputs:
%   pot_3D  is a potential_3D object,
%   time    is a vector of given times at which the user wants to evaluate eta(x,t)
%   x       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   y       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   z       is a vector and represent the vertical   position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
[U_prog, U_evan] = calc_U_lin(pot_3D, x, y, z, time);
[V_prog, V_evan] = calc_V_lin(pot_3D, x, y, z, time);
[W_prog, W_evan] = calc_W_lin(pot_3D, x, y, z, time);
