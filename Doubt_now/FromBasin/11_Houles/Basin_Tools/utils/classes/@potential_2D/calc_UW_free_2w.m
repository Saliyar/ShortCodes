function [U_prog U_evan W_prog W_evan] = calc_UW_free_2w(pot_2D, x, z, time)
% [U_prog U_evan W_prog W_evan] = calc_UW_free_2w(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_UW_FREE_2W evaluates the 2nd order free wave velocities at position x,z
% at time t for the potential_2D object
% Inputs:
%   pot_2D  is a potential_2D object,
%   time    is a vector of given times at which the user wants to evaluate eta(x,t)
%   x       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   z       is a vector and represent the vertical   position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
z = make_it_column(z);
%
pot = set(pot_2D, 'wave', get(pot_2D,'free'));
pot = init_data(pot);
[U_prog, U_evan, W_prog, W_evan] = calc_UW_lin(pot, x, z, time);
