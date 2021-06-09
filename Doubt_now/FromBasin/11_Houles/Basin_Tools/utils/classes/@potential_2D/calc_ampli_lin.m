function [eta_prog, eta_evan] = calc_ampli_lin(pot_2D, x)
% [eta_prog, eta_evan] = calc_ampli_lin(pot_2D, x)
% @POTENTIAL_2D\CALC_AMPLI_LIN evaluates the linear wave amplitude at position x for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
%
if get(pot_2D, 'n_harmo') > 1
    error('wave_2D property should be monochromatic')
end
%
k = get(pot_2D,'wavenumber');
%
% Progressive part
eta_prog = exp(-1i*k*x);
%
% Evanescent part
temp = zeros(size(x));
for n = 2:pot_2D.n_evan+1
    emikx = exp(-1i*pot_2D.alpha_n(1,n)*x);
    temp  = temp + (pot_2D.TF_n(1,n,1)+pot_2D.TF_n(1,n,2)) * emikx;
end
eta_evan = temp;

