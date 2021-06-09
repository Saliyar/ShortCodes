function [eta_prog, eta_evan] = calc_eta_bound(pot_2D, x, time)
% [eta_prog, eta_evan] = calc_eta_lin(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_ETA_LIN evaluates the 2nd order bound wave elevation at position x 
% at time t for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_column(x);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(i*phase);
%
eta_prog = zeros(length(x), length(time));
eta_evan  = zeros(length(x), length(time));
for m=1:length(omega)
    A_bound_mn = calc_A_bound_mn(pot_2D.alpha_n(m,:), squeeze(pot_2D.TF_n(m,:,:)), omega(m));
    a_mn       = (3 * omega(m)^4 - pot_2D.alpha_n(m,:).' * pot_2D.alpha_n(m,:)) / (4*omega(m)^2);
    a_mn       = a_mn .* (sum(pot_2D.TF_n(m,:,:),3).' * sum(pot_2D.TF_n(m,:,:),3));
    a_mn       = a_mn + A_bound_mn;
    % progressive wave
    kpk    = 2 * pot_2D.alpha_n(m,1);
    emikx  = exp(-i*kpk*x);
    temp   = a(m)^2 * a_mn(1,1) * emikx;
    for t=1:length(time)
        eta_prog(:,t) = eta_prog(:,t) + temp .* exp(2*i*omega(m)*time(t));
    end
    % evanescent components
    a_mn(1,1) = 0;
    temp = zeros(size(x));
    for p = 1:pot_2D.n_evan+1
        for n = 1:pot_2D.n_evan+1
            alphapalpha = pot_2D.alpha_n(m,p) + pot_2D.alpha_n(m,n);
            emikx       = exp(-i*alphapalpha*x);
            temp        = temp + a_mn(p,n) * emikx;
        end
    end
    temp = a(m)^2 * temp;
    for t=1:length(time)
        eta_evan(:,t) = eta_evan(:,t) + temp .* exp(2*i*omega(m)*time(t));
    end
end
%
eta_prog = real(eta_prog);
eta_evan = real(eta_evan);
