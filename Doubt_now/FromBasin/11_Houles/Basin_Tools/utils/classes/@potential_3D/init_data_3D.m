function pot_out = init_data_3D(pot_in)
% @POTENTIAL_3D/INIT_DATA_3D
% Every input data is in nondimensional form
%
% See also POTENTIAL_3D, GET, SET, DISPLAY, CALC_AMPLI_LIN, CALC_ETA_LIN
%
N_1 = floor(get(pot_in,'wavenumber') * get(pot_in,'Ly') / pi);
% Number of transverse modes
if pot_in.n_transverse < 0
    pot_in.n_transverse = N_1;
end

pot_out = pot_in;
%
%% First order
%
% Last progressive mode
pot_out.N_1 = N_1;
% transverse wavenumbers
pot_out.mu_n = (0:(pot_in.n_transverse-1)).' * pi / get(pot_in,'Ly');
% main axis wavenumbers
pot_out.k_mn = calc_k_mn(get(pot_in,'alpha_n'), pot_out.mu_n);
pot_out.k_0n = pot_out.k_mn(1,:);
% Transverse projection
if strcmp(get(pot_in,'law'), 'restricted')
    pot_out.I_n  = calc_I_n(pot_out.mu_n, get(pot_in, 'wavenumber'), get(pot_in, 'Ly'), get(pot_in, 'angle')*pi/180, ...
        get(pot_in, 'law'), get(pot_in, 'parameters'));
else
    pot_out.I_n  = calc_I_n(pot_out.mu_n, get(pot_in, 'wavenumber'), get(pot_in, 'Ly'), get(pot_in, 'angle')*pi/180);
end

if get(pot_in, 'active_paddles') ~= 0
    % segmented wavemaker
    active_paddles = get(pot_in, 'active_paddles'); % may be a single flap or several ones.
    pot_out.I_n_j = zeros(length(active_paddles),pot_in.n_transverse);
    for j = 1:length(active_paddles)
        pot_out.I_n_j(j,:)  = calc_I_n(pot_out.mu_n, [], get(pot_in,'Ly'), [], 'single_flap',...
            get(pot_in, 'n_paddles'), active_paddles(j));
    end
end
%
% Amplitudes of modes m=0
%   continuous wavemaker
X_d = get(pot_in,'parameters');
if ~isempty(X_d) % restricted, dalrymple or disc
    X_d = X_d(1);
else % snake case
    X_d = 0;
end
pot_out.a_0n = calc_a_0n(pot_out.I_n, pot_out.k_0n, get(pot_in,'wavenumber'), ...
    get(pot_in,'angle')*pi/180, get(pot_in,'law'), get(pot_in,'Ly'), X_d);
%   segmented wavemaker
if get(pot_in, 'active_paddles') ~= 0
    if strcmp(get(pot_in,'law'),'snake')
        angle = get(pot_in,'angle')*pi/180;
        y_j   = (active_paddles-0.5) * get(pot_in,'Ly') / get(pot_in, 'n_paddles');
        phase_mult = exp(-1i * get(pot_in,'wavenumber') * sin(angle) * y_j);
        phase_mult = make_it_column(phase_mult);
        pot_out.A_0n = pot_out.a_0n ./ pot_out.I_n .* sum((phase_mult * ones(1,pot_in.n_transverse)) .* pot_out.I_n_j, 1);
    elseif strcmp(get(pot_in,'law'),'dalrymple')
        if length(active_paddles) == get(pot_in, 'n_paddles')
%             % we use all the paddles so we can apply the corresponding
%             % expression
%             N_B = get(pot_in, 'n_paddles');
%             %
%             n   = 1:pot_in.n_transverse;
%             pot_out.A_0n(n) = pot_out.k_0n(n) .* pot_out.a_0n(n);
%             n   = max(1, 4*N_B-pot_in.n_transverse+2):min(pot_in.n_transverse,4*N_B+1);
%             pot_out.A_0n(n) = pot_out.A_0n(n) + pot_out.k_0n(4*N_B-n+2) .* pot_out.a_0n(4*N_B-n+2);
%             %
%             n   = 1:pot_in.n_transverse-2*N_B;
%             pot_out.A_0n(n) = pot_out.A_0n(n) - pot_out.k_0n(2*N_B+n) .* pot_out.a_0n(2*N_B+n);
%             n   = 2*N_B+1:pot_in.n_transverse;
%             pot_out.A_0n(n) = pot_out.A_0n(n) - pot_out.k_0n(n-2*N_B) .* pot_out.a_0n(n-2*N_B);
%             n   = max(1, 2*N_B-pot_in.n_transverse+2):min(pot_in.n_transverse,2*N_B+1);
%             pot_out.A_0n(n) = pot_out.A_0n(n) - pot_out.k_0n(2*N_B-n+2) .* pot_out.a_0n(2*N_B-n+2);
%             n   = max(1, 6*N_B-pot_in.n_transverse+2):min(pot_in.n_transverse, 6*N_B+1);
%             pot_out.A_0n(n) = pot_out.A_0n(n) - pot_out.k_0n(6*N_B-n+2) .* pot_out.a_0n(6*N_B-n+2);
%             %
%             n   = 1:pot_in.n_transverse;
%             pot_out.A_0n(n) = pot_out.A_0n(n) .* sinc((n-1) / (2*N_B)) ./ pot_out.k_0n(n);
            % only a incomplete set of paddles
            y_j      = (active_paddles-0.5) * get(pot_in,'Ly') / get(pot_in, 'n_paddles');
            temp_mat = make_it_column(pot_out.mu_n) * make_it_row(y_j);
            a_0n = pot_out.a_0n;
            a_0n(1:pot_out.N_1+1) = a_0n(1:pot_out.N_1+1) ./ sinc((0:pot_out.N_1) / (2*48));
            temp_mat = (make_it_column(pot_out.k_0n .* a_0n) * ones(1,length(active_paddles))) .* cos(temp_mat);
            for n=1:pot_out.n_transverse
                pot_out.A_0n(n) = sum(sum(temp_mat .* (ones(pot_out.n_transverse,1)*(pot_out.I_n_j(:,n).')))) / pot_out.k_0n(n);
            end
        else
            % only a incomplete set of paddles
            y_j      = (active_paddles-0.5) * get(pot_in,'Ly') / get(pot_in, 'n_paddles');
            temp_mat = make_it_column(pot_out.mu_n) * make_it_row(y_j);
            temp_mat = (make_it_column(pot_out.k_0n .* pot_out.a_0n) * ones(1,length(active_paddles))) .* cos(temp_mat);
            for n=1:pot_out.n_transverse
                pot_out.A_0n(n) = sum(sum(temp_mat .* (ones(pot_out.n_transverse,1)*(pot_out.I_n_j(:,n).')))) / pot_out.k_0n(n);
            end
        end
    end
end
%
a = get(pot_in,'amplitude') * exp(1i * get(pot_in,'phase')); 
pot_out.a_0n = pot_out.a_0n * a;
pot_out.A_0n = pot_out.A_0n * a;
%
% Transfer function for m>0
pot_out.TF_mn = calc_TF_mn(pot_out.k_mn, pot_out.k_0n, get(pot_out,'alpha_n'), get(pot_in,'wavenumber'), sum(get(pot_out,'TF_n'),3));
%
%% Second order
%
if (pot_in.n_vertical_free+1) * pot_in.n_transverse_free ~= 0
    pot_free       = set(pot_in,'harmo',2*get(pot_in,'harmo'));
    % Last progressive mode
    pot_out.N_2    = floor(get(pot_free,'wavenumber') * get(pot_in,'Ly') / pi);
    pot_out.beta_m = calc_alpha_n(get(pot_free,'wave'), pot_in.n_vertical_free);
    % main axis wavenumbers
    pot_out.gamma_mn = calc_k_mn(pot_out.beta_m, pot_out.mu_n(1:pot_in.n_transverse_free));
    % free wave amplitudes
    pot_out.a_0n_free = eval_a_0n_free(pot_out);
end
% pot_out.alpha_mnpq_pm = calc_alpha_mnpq_pm(pot_out.k_mn, pot_out.mu_n);
%
% pot_out.a_mnpq_pm = calc_a_mnpq_pm(pot_out.alpha_mnpq_pm, pot_out.TF_mn, pot_out.a_0n, pot_out.k_mn, pot_out.mu_n);
