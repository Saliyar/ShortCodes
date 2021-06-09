function [eta_prog, eta_evan] = calc_eta_lin(pot_3D, x, y, time, error)
% [eta_prog, eta_evan] = calc_eta_lin(pot_3D, x, y, time, error)
% @POTENTIAL_3D\CALC_ETA_LIN evaluates the linear wave elevation at position x at time t for the potential_3D object
% Inputs:
%   pot_3D        is a potential_3D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,y,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   y             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   error         optional, among 'abs' or 'absolute' and 'error'
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN

if nargin == 4
    error = 'none';
end
if length(y) ~= get(pot_3D,'n_transverse')
    [eta_prog, eta_evan] = calc_eta_lin2(pot_3D, x, y, time, error);
else
    x = make_it_row(x);
    y = make_it_column(y);
    %
    omega = get(pot_3D,'omega').';
    %
    ampli = get(pot_3D, 'amplitude');
    k_mn  = get(pot_3D,'k_mn');
    a_mn  = get(pot_3D,'TF_mn') .* (ones(get(pot_3D,'n_evan')+1,1) * get(pot_3D,'a_0n'));

    eta_prog = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mn(1,:) .* exp(1i*omega*time(t));
        temp_a(1,pot_3D.N_1+2:end) = 0;
        temp_k = k_mn(1,:);
        eta_prog(:,:,t) = calc_xy_plane(temp_a,temp_k,x,length(y)).';
    end
    if strcmp(error,'none')
        eta_prog = real(eta_prog);
    elseif strcmp(error,'abs') || strcmp(error,'absolute')
        eta_prog = abs(eta_prog);
    elseif strcmp(error,'error')
        eta_prog = abs(abs(eta_prog)-ampli)/ampli * 100;
        % otherwise give a complex value
    end
    %
    eta_evan = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mn(:,:) .* exp(1i*omega*time(t));
        temp_a(1,1:min(end,pot_3D.N_1+1)) = 0;
        temp_k = k_mn(:,:);
        eta_evan(:,:,t) = calc_xy_plane(temp_a,temp_k,x,length(y)).';
    end
    %
    if strcmp(error,'none')
        eta_evan = real(eta_evan);
    elseif strcmp(error,'abs') || strcmp(error,'absolute')
        eta_evan = abs(eta_evan);
    elseif strcmp(error,'error')
        eta_evan = abs(eta_evan)/ampli * 100;
        % otherwise give a complex value
    end

end