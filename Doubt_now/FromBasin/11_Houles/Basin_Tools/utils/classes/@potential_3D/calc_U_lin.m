function [U_prog, U_evan] = calc_U_lin(pot_3D, x, y, z, time, error)
% [U_prog, U_evan] = calc_U_lin(pot_3D, x, y, time)
% @POTENTIAL_3D\CALC_U_LIN evaluates the linear wave x-velocity at position x,y,z at time t for the potential_3D object
% Inputs:
%   pot_3D        is a potential_3D object,
%   time          is a vector of given times at which the user wants to evaluate U(x,y,t)
%   x             is a vector and represent the horizontal x-position at which the user wants to evaluate the elevation
%   y             is a vector and represent the horizontal y-position at which the user wants to evaluate the elevation
%   z             is a vector and represent the vertical position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN

x = make_it_row(x);
y = make_it_column(y);
%
omega = get(pot_3D,'omega').';
%
alpha_m  = get(pot_3D,'alpha_n');
k_mn  = get(pot_3D,'k_mn');
a_mn  = get(pot_3D,'TF_mn') .* (ones(get(pot_3D,'n_evan')+1,1) * get(pot_3D,'a_0n'));
%
U_prog = zeros(length(x), length(y), length(z), length(time));
for t=1:length(time)
    temp_a = - i * k_mn(1,:) .* a_mn(1,:) .* exp(i*omega*time(t));
    temp_a(1,pot_3D.N_1+2:end) = 0;
    for nz=1:length(z)
        temp_b = temp_a;
        for n=1:size(temp_b,1)
            temp_b(n,:) = temp_b(n,:) * F(+1, alpha_m(n), z(nz));
        end
        U_prog(:,:,nz,t) = calc_xy_plane(temp_b,k_mn(1,:),x,length(y));
    end
end
if nargin == 5
    U_prog = real(U_prog);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    U_prog = abs(U_prog);
    % otherwise give a complex value
end
%
U_evan = zeros(length(x), length(y), length(z), length(time));
for t=1:length(time)
    temp_a = - i * k_mn .* a_mn(:,:) .* exp(i*omega*time(t));
    temp_a(1,1:min(end,pot_3D.N_1+1)) = 0;
    for nz=1:length(z)
        temp_b = temp_a;
        for n=1:size(temp_b,1)
            temp_b(n,:) = temp_b(n,:) * F(+1, alpha_m(n), z(nz));
        end
        U_evan(:,:,nz,t) = calc_xy_plane(temp_b,k_mn,x,length(y));
    end
end
%
if nargin == 5
    U_evan = real(U_evan);
elseif strcmp(error,'abs') || strcmp(error,'absolute')
    U_evan = abs(U_evan);
    % otherwise give a complex value
end
