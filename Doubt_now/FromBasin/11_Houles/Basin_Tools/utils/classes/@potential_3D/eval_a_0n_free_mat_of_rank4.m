function a_0n_free = eval_a_0n_free(pot_3D)

omega = get(pot_3D,'omega').';
%
% First order quantities
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
% [A_mnpq_p A_mnpq_m] =
calc_A_mnpq(a_mn, k_mn, omega, mu_n, beta, alpha_m);
toc
h_wait = waitbar(0,'Please wait...');
for n_prime = 1:get(pot_3D,'n_transverse_free')
    eps     = mod(n_prime,2);       % eps = 1 if n' is even, 0 else (remember that n'=n_prime-1)
    N_prime = floor((n_prime-1)/2); % (remember that n'=n_prime-1)
    if n_prime > 1
        A       = zeros(M,M,max(1,N_prime - eps + 1));
        for n = 1:max(1,N_prime - eps + 1)
            A(:,:,n) = A_mnpq_p(:,n,:,n_prime-n+1);
        end
        result = squeeze(sum(sum(sum(A,1),2),3));
    else
        result = 0;
    end
    %
    result = result + eps/2 * sum(sum(squeeze(A_mnpq_p(:,N_prime+1,:,n_prime-N_prime))));
    %
    %     A       = zeros(M,M,n_prime);
    %     for n = 1:n_prime
    %         A(:,:,n) = A_mnpq_p(:,n,:,n_prime-n+1);
    %     end
    %     result2 = 0.5 * squeeze(sum(sum(sum(A,1),2),3));
    %     %
    %     disp(['+ ' num2str(result == result2) '  ' num2str(result) ' ' num2str(result2) ' ' num2str(abs(result-result2)/abs(result)*100)])
    %
    A      = zeros(M,M,n_trsv - n_prime + 1);
    for n = 1:n_trsv - n_prime + 1
        A(:,:,n) = A_mnpq_m(:,n,:,n_prime+n-1);
    end
    result1 = squeeze(sum(sum(sum(A,1),2),3));
    if n_prime == 1
        result1 = result1 / 2;
    end
    %
    %     A      = zeros(M,M,n_trsv - n_prime + 1);
    %     for n = 1:n_trsv - n_prime + 1
    %         A(:,:,n) = A_mnpq_m(:,n_prime+n-1,:,n);
    %     end
    %     result2 = squeeze(sum(sum(sum(A,1),2),3));
    %     disp(['- ' num2str(result1 == result2) '  ' num2str(result1) ' ' num2str(result2) ' ' num2str(abs(result1-result2)/abs(result1)*100)])
    %
    result = result + result1;
    %
    a_0n_free(n_prime) = result / gamma_mn(1, n_prime);
    %
    waitbar(n_prime/(get(pot_3D,'n_transverse_free')-1))
end
%
close(h_wait),pause(0.01) % for the waitbar window to close
%
a_0n_free = a_0n_free / 2  * beta * (exp(beta) + exp(-beta))^2 / (2*beta + (exp(2*beta) - exp(-2*beta)) / 2);
%

    function calc_A_mnpq(a_mn, k_mn, omega, mu_n, beta_m, alpha_m)
        % Array sizes
        M = size(a_mn,1);
        N = size(a_mn,2);
        P = M;
        Q = N;
        final = [M,N,P,Q];
        %
        kpk_a_a         = extend(a_mn, [M,N,1,1], final) .* extend(a_mn, [1,1,P,Q], final);
        temp_4          = extend(k_mn, [M,N,1,1], final);
        temp_5          = extend(k_mn, [1,1,P,Q], final);
        temp_6          = temp_4 + temp_5;
        kpk_a_a         = temp_6 .* kpk_a_a;
        temp_6          = temp_6.^2;
        kmn_kpq         = temp_4 .* temp_5;
        %
        temp_4          = extend(alpha_m, [M,1,1,1], final);
        temp_5          = extend(alpha_m, [1,1,P,1], final);
        alpha_mtp       = temp_4 .* temp_5;
        one_ovr_2alpha  = 1 ./ (2*alpha_mtp);
        alpha_mpp2      = (temp_4  + temp_5).^2;
        alpha_mmp2      = (temp_4  - temp_5).^2;
        %
        temp_4          = extend(mu_n, [1,N,1,1], final);
        temp_5          = extend(mu_n, [1,1,1,Q], final);
        mun_muq         = temp_4 .* temp_5;
        %
        sig          = +1;
        alpha_mnpq_2 = temp_6 + (temp_4 + sig * temp_5).^2;
        %
        A_mnpq_p = kpk_a_a .* (...
            (6*omega^4 - alpha_mnpq_2 - 2 * kmn_kpq - sig * 2 * mun_muq) ./ (beta_m^2 - alpha_mnpq_2) + ...
            (alpha_mtp + kmn_kpq - sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mmp2) ./ (beta_m^2 - alpha_mpp2) + ...
            (alpha_mtp - kmn_kpq + sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mpp2) ./ (beta_m^2 - alpha_mmp2));
        %
        sig          = -1;
        alpha_mnpq_2 = temp_6 + (temp_4 + sig * temp_5).^2;
        %
        A_mnpq_m = kpk_a_a .* (...
            (6*omega^4 - alpha_mnpq_2 - 2 * kmn_kpq - sig * 2 * mun_muq) ./ (beta_m^2 - alpha_mnpq_2) + ...
            (alpha_mtp + kmn_kpq - sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mmp2) ./ (beta_m^2 - alpha_mpp2) + ...
            (alpha_mtp - kmn_kpq + sig * mun_muq) .* one_ovr_2alpha .* (4*omega^4 - alpha_mpp2) ./ (beta_m^2 - alpha_mmp2));
    end

    function A = extend(a, initial, final)
        %
        extracted(1:4) = num2cell(ones(1,4));
        extended(1:4)  = num2cell(ones(1,4));
        %
        for i=1:4
            if initial(i) == final(i);
                extracted{i} = 1:final(i);
            else
                extended{i}  = final(i);
            end
        end
        %
        A(extracted{1:4}) = a;
        %
        A = repmat(A, [extended{1:4}]);
    end

end