function [eta_prog, eta_evan] = calc_eta_lin2(pot_3D, x, y, time, error)
% [eta_prog, eta_evan] = calc_eta_lin2(pot_3D, x, y, time)
% @POTENTIAL_3D\CALC_ETA_LIN evaluates the linear wave elevation at position x at time t for the potential_3D object
% Inputs: 
%   pot_3D        is a potential_3D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,y,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   y             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN
x = make_it_row(x);
y = make_it_column(y);
%
omega = get(pot_3D,'omega').';
ampli = get(pot_3D, 'amplitude');
%
tic
eta_prog = zeros(length(y), length(x), length(time));
temp     = zeros(length(y), length(x));
% pot_3D.a_0n = zeros(size(pot_3D.a_0n));
% pot_3D.a_0n(2) = 1/a;
for n=1:min(length(pot_3D.k_0n),pot_3D.N_1+1)
    emikx  = exp(-i*pot_3D.k_0n(n)*x);
    cosmuy = cos(pot_3D.mu_n(n) * y);
    temp   = temp + pot_3D.a_0n(n) * cosmuy * emikx;
end
for t=1:length(time)
    eta_prog(:,:,t) = temp .* exp(i*omega*time(t));
end
%
toc
if nargin == 4
    eta_prog = real(eta_prog);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    eta_prog = abs(eta_prog);
elseif strcmp(error,'error')
    eta_prog = abs(abs(eta_prog)-ampli)/ampli * 100;
% otherwise give a complex value
end
%
tic
eta_evan = zeros(length(y), length(x), length(time));
temp     = zeros(length(y), length(x));
for n=pot_3D.N_1+2:pot_3D.n_transverse
    cosmuy = cos(pot_3D.mu_n(n) * y);
    emikx  = exp(-i*pot_3D.k_0n(n)*x);
    temp   = temp + pot_3D.a_0n(n) * cosmuy * emikx;
end
for n=1:pot_3D.n_transverse
    cosmuy = cos(pot_3D.mu_n(n) * y);
    for m=2:get(pot_3D, 'n_evan')+1
        emikx = exp(-i*pot_3D.k_mn(m,n)*x);
        temp  = temp + pot_3D.TF_mn(m,n) * pot_3D.a_0n(n) * cosmuy * emikx;
    end
end
for t=1:length(time)
    eta_evan(:,:,t) = temp .* exp(i*omega*time(t));
end
%
toc
if nargin == 4
    eta_evan = real(eta_evan);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    eta_evan = abs(eta_evan);
elseif strcmp(error,'error')
    eta_evan = abs(eta_evan)/ampli * 100;
% otherwise give a complex value
end

