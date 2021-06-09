function [eta_prog, eta_evan] = calc_eta_free(pot_2D, x, time)
% [eta_prog, eta_evan] = calc_eta_free(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_ETA_FREE evaluates the 2nd order free wave elevation at position x 
% at time t for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_column(x);
%
pot = set(pot_2D, 'wave', get(pot_2D,'free'));
pot = set(pot,    'free', wave());
[eta_prog, eta_evan] = calc_eta_lin(pot, x, time);
