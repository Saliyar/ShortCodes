function [U_prog, U_evan] = calc_U_lin(pot_2D, x, z, time)
% [U_prog, U_evan] = calc_U_lin(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_U_LIN evaluates the linear wave velocities at position x,z at time t for the potential_2D object
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
k = wave_number(get(pot_2D,'frequency').');
%
U_prog = zeros(length(z), length(x), length(time));
for n=1:length(k)
    Fpz   = F(+1,k(n),z);
    emikx = exp(-i*k(n)*x);
    temp  = k(n) * a(n) / omega(n) * Fpz * emikx;
    for t=1:length(time)
        U_prog(:,:,t) = U_prog(:,:,t) + temp .* exp(i*omega(n)*time(t));
    end
end
%
U_prog = real(U_prog);
%
U_evan  = zeros(length(z), length(x), length(time));
for m=1:length(k)
    temp = zeros(length(z), length(x));
    for n = 2:pot_2D.n_evan+1
        Fpz   = F(+1,pot_2D.alpha_n(m,n),z);
        emikx = exp(-i*pot_2D.alpha_n(m,n)*x);
        temp  = temp + pot_2D.alpha_n(m,n) * (pot_2D.TF_n(m,n,1)+pot_2D.TF_n(m,n,2)) * Fpz * emikx;
    end
    temp = a(m) / omega(m) * temp;
    for t=1:length(time)
        U_evan(:,:,t) = U_evan(:,:,t) + temp .* exp(i*omega(m)*time(t));
    end
end
%
U_evan = real(U_evan);
