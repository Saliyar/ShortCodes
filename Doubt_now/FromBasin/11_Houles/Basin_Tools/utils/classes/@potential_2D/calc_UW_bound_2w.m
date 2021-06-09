function [U_prog U_evan W_prog W_evan] = calc_UW_bound_2w(pot_2D, x, z, time)
% [U_prog U_evan W_prog W_evan] = calc_UW_bound_2w(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_UW_BOUND_2W evaluates the 2nd order bound wave velocities at position x,z
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
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(1i*phase);
%

U_prog = zeros(length(z), length(x), length(time));
W_prog = zeros(length(z), length(x), length(time));
U_evan = zeros(length(z), length(x), length(time));
W_evan = zeros(length(z), length(x), length(time));
for m=1:length(omega)
    A_bound_mn = calc_A_bound_mn(pot_2D.alpha_n(m,:), squeeze(pot_2D.TF_n(m,:,:)), omega(m));
    % progressive wave
    kpk    = 2 * pot_2D.alpha_n(m,1);
    Fpz    = F(+1,kpk,z);
    Fmz    = F(-1,kpk,z);
    emikx  = exp(-1i*kpk*x);
    tempU  =  - 1i * kpk * A_bound_mn(1,1) * Fpz * emikx;
    tempW  =        kpk * A_bound_mn(1,1) * Fmz * emikx;
    tempU  = 1i * a(m)^2 * tempU / (2*omega(m));
    tempW  = 1i * a(m)^2 * tempW / (2*omega(m));
    for t=1:length(time)
        U_prog(:,:,t) = U_prog(:,:,t) + tempU .* exp(2*1i*omega(m)*time(t));
        W_prog(:,:,t) = W_prog(:,:,t) + tempW .* exp(2*1i*omega(m)*time(t));
    end
    % evanescent components
    A_bound_mn(1,1) = 0;
    tempU = zeros(length(z), length(x));
    tempW = zeros(length(z), length(x));
    for p = 1:pot_2D.n_evan+1
        for n = 1:pot_2D.n_evan+1
            alphapalpha = pot_2D.alpha_n(m,p) + pot_2D.alpha_n(m,n);
            Fpz         = F(+1,alphapalpha,z);
            Fmz         = F(-1,alphapalpha,z);
            emikx       = exp(-i*alphapalpha*x);
            tempU       = tempU - i * alphapalpha * A_bound_mn(p,n) * Fpz * emikx;
            tempW       = tempW +     alphapalpha * A_bound_mn(p,n) * Fmz * emikx;
        end
    end
    tempU   = i * a(m)^2 * tempU / (2*omega(m));
    tempW   = i * a(m)^2 * tempW / (2*omega(m));
    for t=1:length(time)
        U_evan(:,:,t) = U_evan(:,:,t) + tempU .* exp(2*i*omega(m)*time(t));
        W_evan(:,:,t) = U_evan(:,:,t) + tempW .* exp(2*i*omega(m)*time(t));
    end
end
%
U_prog = real(U_prog);
W_prog = real(W_prog);
U_evan = real(U_evan);
W_evan = real(W_evan);
