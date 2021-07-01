function [U, U_evan, W_evan] = calc_UW_free_indep(pot_2D, x, z, n_evan)
% [U, U_evan, W_evan] = calc_UW_free_indep(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_UW_FREE_INDEP evaluates the 2nd order free wave velocities at position x,z at time t for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x (optional)  is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   z (optional)  is a vector and represent the vertical   position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
z = make_it_column(z);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(i*phase);
%
k = get(pot_2D,'wavenumber');
%
U = zeros(length(z), length(x));
for n=1:length(omega)
    U = U - k(n) * a(n) * conj(a(n)) / (2*omega(n)) * ones(length(z), length(x));
end
%
U = real(U);
%
if nargin < 4
    n_evan = pot_2D.n_evan;
end
%
U_evan = zeros(length(z), length(x));
W_evan = zeros(length(z), length(x));
for m=1:length(omega)
    tempU = zeros(length(z), length(x));
    tempW = zeros(length(z), length(x));
    for n = 2:n_evan+1
        Fpz         = F(+1,pot_2D.sigma_n(n),z);
        Fmz         = F(-1,pot_2D.sigma_n(n),z);
        emikx       = exp(-i*pot_2D.sigma_n(n)*x);
        a_l_n_indep = calc_a_l_n_indep(omega(m), pot_2D.alpha_n(m,:), ...
            pot_2D.TF_n(m,:,1)+pot_2D.TF_n(m,:,2), pot_2D.sigma_n(n));
        tempU        = tempU - i * pot_2D.sigma_n(n) * a_l_n_indep * Fpz * emikx;
        tempW        = tempW +     pot_2D.sigma_n(n) * a_l_n_indep * Fmz * emikx;
    end
    tempU   = i * a(m) * conj(a(m)) * tempU;
    U_evan = U_evan + tempU;
    tempW   = i * a(m) * conj(a(m)) * tempW;
    W_evan = W_evan + tempW;
end
%
U_evan = real(U_evan);
W_evan = real(W_evan);