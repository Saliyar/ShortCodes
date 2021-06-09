function a_0n_free = eval_a_0n_free(pot_3D)


% First order quantities
omega   = get(pot_3D,'omega').';
alpha_m = get(pot_3D,'alpha_n');
mu_n    = get(pot_3D,'mu_n');
n_trsv  = length(mu_n);
k_mn    = get(pot_3D,'k_mn');
a_mn    = get(pot_3D,'TF_mn') .* (ones(get(pot_3D,'n_evan')+1,1) * get(pot_3D,'a_0n'));
% Second order quantities
beta_m   = get(pot_3D,'beta_m');
gamma_mn = get(pot_3D,'gamma_mn');

M = size(a_mn,1);

a_0n_free = zeros(1,get(pot_3D,'n_transverse_free'));

beta = beta_m(1);
tic
h_wait = waitbar(0,'Evaluating a_{0n} for free waves, please wait...');
for n_prime = 1:get(pot_3D,'n_transverse_free')
    eps     = mod(n_prime,2);       % eps = 1 if n' is even, 0 else (remember that n'=n_prime-1)
    N_prime = floor((n_prime-1)/2); % (remember that n'=n_prime-1)
    sum2_A  = zeros(1,N_prime+1);
    for n = 1:N_prime+1
        A         = calc_A_mnpq(+1, a_mn, k_mn, omega, mu_n, beta, alpha_m, n, n_prime-n+1);
        sum2_A(n) = sum(sum(A,1),2);
    end
    result = eps / 2 * sum2_A(N_prime + 1) + sum(sum2_A(1:N_prime+1-eps));
    %
    sum2_A  = zeros(1,n_trsv - n_prime + 1);
    for n = 1:n_trsv - n_prime + 1
        A         = calc_A_mnpq(-1, a_mn, k_mn, omega, mu_n, beta, alpha_m, n, n_prime+n-1);
        sum2_A(n) = sum(sum(A,1),2);
    end
    result1 = sum(sum2_A);
    if n_prime == 1
        result1 = result1 / 2;
    end
    %
    result = result + result1;
    %
    a_0n_free(n_prime) = result / gamma_mn(1, n_prime);
    %
    waitbar(n_prime/(get(pot_3D,'n_transverse_free')-1))
end
%
toc
close(h_wait),pause(0.01) % for the waitbar window to close
%
a_0n_free = a_0n_free / 2  * beta * (exp(beta) + exp(-beta))^2 / (2*beta + (exp(2*beta) - exp(-2*beta)) / 2);
%

    function A_mnpq = calc_A_mnpq(sig, a_mn, k_mn, omega, mu_n, beta_m, alpha_m, n, q)
        % Array sizes
        M = size(a_mn,1);
        P = M;
        final = [M,P];
        %
        kpk_a_a         = extend(a_mn(:,n), [M,1], final) .* extend(a_mn(:,q), [1,P], final);
        temp_4          = extend(k_mn(:,n), [M,1], final);
        temp_5          = extend(k_mn(:,q), [1,P], final);
        temp_6          = temp_4 + temp_5;
        kpk_a_a         = temp_6 .* kpk_a_a;
        temp_6          = temp_6.^2;
        kmn_kpq         = temp_4 .* temp_5;
        %
        temp_4          = extend(alpha_m, [M,1], final);
        temp_5          = extend(alpha_m, [1,P], final);
        alpha_mtp       = temp_4 .* temp_5;
        one_ovr_2alpha  = 1 ./ (2*alpha_mtp);
        alpha_mpp2      = (temp_4  + temp_5).^2;
        alpha_mmp2      = (temp_4  - temp_5).^2;
        %
        temp_4          = extend(mu_n(n), [1,1], final);
        temp_5          = extend(mu_n(q), [1,1], final);
        mun_muq         = temp_4 .* temp_5;
        %
        alpha_mnpq_2 = temp_6 + (temp_4 + sig * temp_5).^2;
        %
        A_mnpq = kpk_a_a .* (...
            (6*omega^4 - alpha_mnpq_2 - 2 * kmn_kpq - sig * 2 * mun_muq) ./ (beta_m^2 - alpha_mnpq_2) + ...
            (alpha_mtp + kmn_kpq - sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mmp2) ./ (beta_m^2 - alpha_mpp2) + ...
            (alpha_mtp - kmn_kpq + sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mpp2) ./ (beta_m^2 - alpha_mmp2));
    end

    function A = extend(a, initial, final)
        %
        extracted(1:2) = num2cell(ones(1,2));
        extended(1:2)  = num2cell(ones(1,2));
        %
        for i=1:2
            if initial(i) == final(i);
                extracted{i} = 1:final(i);
            else
                extended{i}  = final(i);
            end
        end
        %
        A(extracted{1:2}) = a;
        %
        A = repmat(A, [extended{1:2}]);
    end

end