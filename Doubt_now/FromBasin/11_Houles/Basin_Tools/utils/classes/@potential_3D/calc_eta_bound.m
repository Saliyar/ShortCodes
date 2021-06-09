function [eta_prog_p, eta_evan_p, eta_prog_m, eta_evan_m] = calc_eta_bound(pot_3D, x, y, time, Ny_max, error_type)
% [eta_prog, eta_evan] = calc_eta_bound(pot_3D, x, y, time)
% @POTENTIAL_3D\CALC_ETA_LIN evaluates the second order bound wave elevation at position x at time t for the potential_3D object
% Inputs:
%   pot_3D        is a potential_3D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,y,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   y             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN

if length(y) ~= get(pot_3D,'n_transverse')
    error('calc_eta_bound:y','Mismatch in transverse dimension. Check length(y) and n_transverse')
else
    if nargin < 5
        Ny_max = length(y);
    end
    x = make_it_row(x);
    y = make_it_column(y);
    %
    omega = get(pot_3D,'omega').';
    %
    mu_n  = get(pot_3D,'mu_n');
    k_mn  = get(pot_3D,'k_mn');
    a_mn  = get(pot_3D,'TF_mn') .* (ones(get(pot_3D,'n_evan')+1,1) * get(pot_3D,'a_0n'));
    M = size(a_mn,1);
    N = size(a_mn,2);
    P = M;
    Q = N;
    final = [M,N,P,Q];

    pre_calc(a_mn, k_mn, mu_n)

    sig = -1;
    alpha_mnpq_2 = temp_6 + (temp_4 + sig * temp_5).^2;
    alpha_mnpq   = sqrt(alpha_mnpq_2);
    %
    a_mnpq = amn_apq / 4 .*((6*omega^4 - alpha_mnpq_2 - 2*kmn_kpq - sig*2*mun_muq) ./ (-4*omega^2 + alpha_mnpq.*F(-1,alpha_mnpq,0)) + ...
        (3*omega^4 - kmn_kpq - sig * mun_muq) ./ (2*omega^2));

    eta_prog_p = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mnpq(1,:,1,:) .* exp(2*i*omega*time(t));
        temp_a(1,pot_3D.N_1+2:end,1,:) = 0;
        temp_a(1,:,1,pot_3D.N_1+2:end) = 0;
        temp_k = k_mn(1,:);
        eta_prog_p(:,:,t) = calc_xy_plane_2nd(+1,temp_a,temp_k,x,length(y),min(length(y),Ny_max)).';
    end
    if nargin < 6
        eta_prog_p = real(eta_prog_p);
    elseif strcmp(error_type,'abs') || strcmp(error_type,'absolute')
        eta_prog_p = abs(eta_prog_p);
    elseif strcmp(error_type,'error')
        eta_prog_p = abs(abs(eta_prog_p)-ampli)/ampli * 100;
        % otherwise give a complex value
    end
    %
    eta_evan_p = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mnpq(:,:,:,:) .* exp(2*i*omega*time(t));
        temp_a(1,1:min(end,pot_3D.N_1+1),:,:) = 0;
        temp_a(:,:,1,1:min(end,pot_3D.N_1+1)) = 0;
        temp_k = k_mn(:,:);
        eta_evan_p(:,:,t) = calc_xy_plane_2nd(+1,temp_a,temp_k,x,length(y),min(length(y),Ny_max)).';
    end
    %
    if nargin < 6
        eta_evan_p = real(eta_evan_p);
    elseif strcmp(error_type,'abs') || strcmp(error_type,'absolute')
        eta_evan_p = abs(eta_evan_p);
    elseif strcmp(error_type,'error')
        eta_evan_p = abs(eta_evan_p)/ampli * 100;
        % otherwise give a complex value
    end

    sig = -1;
    alpha_mnpq_2 = temp_6 + (temp_4 + sig * temp_5).^2;
    alpha_mnpq   = sqrt(alpha_mnpq_2);
    %
    a_mnpq = amn_apq / 4 .*((6*omega^4 - alpha_mnpq_2 - 2*kmn_kpq - sig*2*mun_muq) ./ (-4*omega^2 + alpha_mnpq.*F(-1,alpha_mnpq,0)) + ...
        (3*omega^4 - kmn_kpq - sig * mun_muq) ./ (2*omega^2));

    eta_prog_m = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mnpq(1,:,1,:) .* exp(2*i*omega*time(t));
        temp_a(1,pot_3D.N_1+2:end,1,:) = 0;
        temp_a(1,:,1,pot_3D.N_1+2:end) = 0;
        temp_k = k_mn(1,:);
        eta_prog_m(:,:,t) = calc_xy_plane_2nd(-1,temp_a,temp_k,x,length(y),min(length(y),Ny_max)).';
    end
    if nargin < 6
        eta_prog_m = real(eta_prog_m);
    elseif strcmp(error_type,'abs') || strcmp(error_type,'absolute')
        eta_prog_m = abs(eta_prog_m);
    elseif strcmp(error_type,'error')
        eta_prog_m = abs(abs(eta_prog_m)-ampli)/ampli * 100;
        % otherwise give a complex value
    end
    %
    eta_evan_m = zeros(length(y), length(x), length(time));
    for t=1:length(time)
        temp_a = a_mnpq(:,:,:,:) .* exp(2*i*omega*time(t));
        temp_a(1,1:min(end,pot_3D.N_1+1),:,:) = 0;
        temp_a(:,:,1,1:min(end,pot_3D.N_1+1)) = 0;
        temp_k = k_mn(:,:);
        eta_evan_m(:,:,t) = calc_xy_plane_2nd(-1,temp_a,temp_k,x,length(y),min(length(y),Ny_max)).';
    end
    %
    if nargin < 6
        eta_evan_m = real(eta_evan_m);
    elseif strcmp(error_type,'abs') || strcmp(error_type,'absolute')
        eta_evan_m = abs(eta_evan_m);
    elseif strcmp(error_type,'error')
        eta_evan_m = abs(eta_evan_m)/ampli * 100;
        % otherwise give a complex value
    end


end


    function pre_calc(a_mn, k_mn, mu_n)
        % Array sizes
        M = size(a_mn,1);
        N = size(a_mn,2);
        P = M;
        Q = N;
        final = [M,N,P,Q];
        %
        amn_apq         = extend(a_mn, [M,N,1,1], final) .* extend(a_mn, [1,1,P,Q], final);
        temp_4          = extend(k_mn, [M,N,1,1], final);
        temp_5          = extend(k_mn, [1,1,P,Q], final);
        temp_6          = temp_4 + temp_5;
        temp_6          = temp_6.^2;
        kmn_kpq         = temp_4 .* temp_5;
        %
        temp_4          = extend(mu_n, [1,N,1,1], final);
        temp_5          = extend(mu_n, [1,1,1,Q], final);
        mun_muq         = temp_4 .* temp_5;
        %
    end

    function A = extend(a, initial, final)
        %
        extracted(1:4) = num2cell(ones(1,4));
        extended(1:4)  = num2cell(ones(1,4));
        %
        for j=1:4
            if initial(j) == final(j);
                extracted{j} = 1:final(j);
            else
                extended{j}  = final(j);
            end
        end
        %
        A(extracted{1:4}) = a;
        %
        A = repmat(A, [extended{1:4}]);
    end

end