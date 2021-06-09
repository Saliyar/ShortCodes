function [eta_prog, eta_evan] = calc_ampli_lin(pot_3D, x, y)
% [eta_prog, eta_evan] = calc_ampli_lin(pot_3D, x, y)
% @POTENTIAL_3D\CALC_AMPLI_LIN evaluates the linear wave amplitude at position x,y for the potential_3D object
% Inputs: 
%   pot_3D        is a potential_3D object,
%   x             is a vector and represent the horizontal position where
%                   the user wants to evaluate the amplitude
%   y             is a vector and represent the horizontal position where
%                   the user wants to evaluate the amplitude
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, INIT_DATA, CALC_ETA_LIN
x = make_it_row(x);
y = make_it_column(y);
%
temp = zeros(length(y), length(x));
for n=1:pot_3D.N_1+1
    emikx  = exp(-1i*pot_3D.k_0n(n)*x);
    cosmuy = cos(pot_3D.mu_n(n) * y);
    temp   = temp + pot_3D.a_0n(n) * cosmuy * emikx;
end
eta_prog(:,:) = temp;
%
temp = zeros(length(y), length(x));
for n=pot_3D.N_1+2:pot_3D.n_transverse
    cosmuy = cos(pot_3D.mu_n(n) * y);
    emikx  = exp(-1i*pot_3D.k_0n(n)*x);
    temp  = temp + pot_3D.a_0n(n) * cosmuy * emikx;
end
for n=1:pot_3D.n_transverse
    cosmuy = cos(pot_3D.mu_n(n) * y);
    for m=2:get(pot_3D, 'n_evan')+1
        emikx = exp(-1i*pot_3D.k_mn(m,n)*x);
        temp  = temp + pot_3D.TF_mn(m,n) * pot_3D.a_0n(n) * cosmuy * emikx;
    end
end
%
eta_evan = temp;
