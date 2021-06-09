function [U_prog, U_evan, W_prog, W_evan] = calc_UW_lin(pot_2D, x, z, time)
% [U_prog, U_evan, W_prog, W_evan] = calc_UW_lin(pot_2D, x, z, time)
% @POTENTIAL_2D\CALC_UW_LIN evaluates the linear wave velocities at position x,z at time t for the potential_2D object
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
a = ampli .* exp(i*phase);
%
k = wave_number(get(pot_2D,'frequency').');
%
U_prog = zeros(length(z), length(x), length(time));
W_prog = zeros(length(z), length(x), length(time));
for n=1:length(k)
    Fpz   = F(+1,k(n),z);
    Fmz   = F(-1,k(n),z);
    emikx = exp(-i*k(n)*x);
    temp  = i * k(n) * a(n) / omega(n) * emikx;
    for t=1:length(time)
        U_prog(:,:,t) = U_prog(:,:,t) - i * Fpz * temp .* exp(i*omega(n)*time(t));
        W_prog(:,:,t) = W_prog(:,:,t) +     Fmz * temp .* exp(i*omega(n)*time(t));
    end
end
%
U_prog = real(U_prog);
W_prog = real(W_prog);
%
U_evan  = zeros(length(z), length(x), length(time));
W_evan  = zeros(length(z), length(x), length(time));
for m=1:length(k)
    tempU = zeros(length(z), length(x));
    tempW = zeros(length(z), length(x));
    for n = 2:pot_2D.n_evan+1
        Fpz   = F(+1,pot_2D.alpha_n(m,n),z);
        Fmz   = F(-1,pot_2D.alpha_n(m,n),z);
        emikx = exp(-i*pot_2D.alpha_n(m,n)*x);
        tempU = tempU + pot_2D.alpha_n(m,n) * (pot_2D.TF_n(m,n,1)+pot_2D.TF_n(m,n,2)) * Fpz * emikx;
        tempW = tempW + pot_2D.alpha_n(m,n) * (pot_2D.TF_n(m,n,1)+pot_2D.TF_n(m,n,2)) * Fmz * emikx;
    end
    tempU = i * a(m) / omega(m) * tempU;
    tempW = i * a(m) / omega(m) * tempW;
    for t=1:length(time)
        U_evan(:,:,t) = U_evan(:,:,t) - i * tempU .* exp(i*omega(m)*time(t));
        W_evan(:,:,t) = U_evan(:,:,t) +     tempW .* exp(i*omega(m)*time(t));
    end
end
%
U_evan = real(U_evan);
W_evan = real(W_evan);
