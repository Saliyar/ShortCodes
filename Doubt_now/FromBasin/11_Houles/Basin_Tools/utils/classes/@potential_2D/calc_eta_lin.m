function [eta_prog, eta_evan] = calc_eta_lin(pot_2D, x, time)
% [eta_prog, eta_evan] = calc_eta_lin(pot_2D, x, time)
% @POTENTIAL_2D\CALC_ETA_LIN evaluates the linear wave elevation at position x at time t for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
%
x = make_it_column(x);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(1i*phase);
%
k = wave_number(get(pot_2D,'frequency').');
%
eta_prog = zeros(length(x), length(time));
for n=1:length(k)
    emikx = exp(- 1i*k(n)*x);
    temp  = a(n) * emikx;
    for t=1:length(time)
        eta_prog(:,t) = eta_prog(:,t) + temp .* exp(1i*omega(n)*time(t));
    end
end
%
eta_prog = real(eta_prog);
%
eta_evan  = zeros(length(x), length(time));
for m=1:length(k)
    temp = zeros(size(x));
    for n = 2:pot_2D.n_evan+1
        emikx = exp(-1i*pot_2D.alpha_n(m,n)*x);
        temp  = temp + (pot_2D.TF_n(m,n,1)+pot_2D.TF_n(m,n,2)) * emikx;
    end
    temp = a(m) * temp;
    for t=1:length(time)
        eta_evan(:,t) = eta_evan(:,t) + temp .* exp(1i*omega(m)*time(t));
    end
end
%
eta_evan = real(eta_evan);
