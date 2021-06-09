function [U_evan, W_evan] = calc_UW_bound_indep(pot_2D, x, z)
% [U_evan W_evan] = calc_UW_bound_indep(pot_2D, x, z)
% @POTENTIAL_2D\CALC_UW_BOUND_INDEP evaluates the 2nd order bound wave velocities at position x,z 
% at time t for the potential_2D object
% Inputs:
%   pot_2D  is a potential_2D object,
%   x       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   z       is a vector and represent the vertical   position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
z = make_it_column(z);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(1i*phase);
%
U_evan = zeros(length(z), length(x));
W_evan = zeros(length(z), length(x));
for m=1:length(omega)
    tempU = zeros(length(z), length(x));
    tempW = zeros(length(z), length(x));
    B_0n = calc_B_0n(omega(m), pot_2D.alpha_n(m,:), pot_2D.TF_n(m,:,1)+pot_2D.TF_n(m,:,2));
    for n = 2:pot_2D.n_evan+1
        kmalpha     = pot_2D.alpha_n(m,1) - conj(pot_2D.alpha_n(m,n));
        Fpz         = F(+1,kmalpha,z);
        Fmz         = F(-1,kmalpha,z);
        emikx       = exp(-1i*kmalpha*x);
        tempU        = tempU - 1i * kmalpha * B_0n(n) * Fpz * emikx;
        tempW        = tempW +     kmalpha * B_0n(n) * Fmz * emikx;
    end
    tempU   = 1i * a(m) * conj(a(m)) * tempU;
    U_evan = U_evan + tempU;
    tempW   = 1i * a(m) * conj(a(m)) * tempW;
    W_evan = W_evan + tempW;
end
%
U_evan = real(U_evan);
W_evan = real(W_evan);
