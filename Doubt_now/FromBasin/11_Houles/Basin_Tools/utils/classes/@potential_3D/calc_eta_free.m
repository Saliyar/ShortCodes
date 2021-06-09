function [eta_prog, eta_evan] = calc_eta_free(pot_3D, x, y, time, Ny_max, error)
% [eta_prog, eta_evan] = calc_eta_free(pot_3D, x, z, time)
% @POTENTIAL_3D\CALC_ETA_FREE evaluates the 2nd order free wave elevation at position x
% at time t for the potential_3D object
% Inputs:
%   pot_2D        is a potential_3D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
y = make_it_column(y);
%
omega = get(pot_3D,'omega').';
%
gamma_mn = zeros(get(pot_3D,'n_vertical_free')+1, length(y));
n_t_f    = get(pot_3D,'n_transverse_free')-1;
gamma_mn(:,1:n_t_f+1) = get(pot_3D,'gamma_mn');
% gamma_mn = get(pot_3D,'gamma_mn');
%
a_mn_free = zeros(get(pot_3D,'n_vertical_free')+1, length(y));
a_mn_free(1,1:n_t_f+1) = get(pot_3D,'a_0n_free');
%
eta_prog = zeros(length(y), length(x), length(time));
for t=1:length(time)
    temp_a = a_mn_free(1,:) .* exp(2*i*omega*time(t));
    temp_a(1,pot_3D.N_2+2:end) = 0;
    temp_k = gamma_mn(1,:);
    eta_prog(:,:,t) = calc_xy_plane(temp_a,temp_k,x,length(y)).';
end
%
ampli = get(pot_3D,'ampli').';
%
if nargin == 4
    eta_prog = real(eta_prog);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    eta_prog = abs(eta_prog);
elseif strcmp(error,'Stokes') || strcmp(error,'stokes')
    eta_bd   = get(pot_3D,'wavenumber') * ampli^2 / 2;
    eta_prog = abs(eta_prog) / eta_bd;
elseif strcmp(error,'Stokes_rel') || strcmp(error,'stokes_rel')
    eta_bd   = get(pot_3D,'wavenumber') * ampli^2 / 2;
    eta_prog = abs(abs(eta_prog)-eta_bd)/eta_bd * 100;
    % otherwise give a complex value
end
%
eta_evan = zeros(length(y), length(x), length(time));
for t=1:length(time)
    temp_a = a_mn_free(:,:) .* exp(i*omega*time(t));
    temp_a(1,1:min(end,pot_3D.N_2+1)) = 0;
    temp_k = gamma_mn(:,:);
    eta_evan(:,:,t) = calc_xy_plane(temp_a,temp_k,x,length(y)).';
end
%
if nargin == 4
    eta_evan = real(eta_evan);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    eta_evan = abs(eta_evan);
elseif strcmp(error,'Stokes') || strcmp(error,'stokes')
    eta_bd   = get(pot_3D,'wavenumber') * ampli^2 / 2;
    eta_evan = abs(eta_evan) / eta_bd;
    % otherwise give a complex value
end
