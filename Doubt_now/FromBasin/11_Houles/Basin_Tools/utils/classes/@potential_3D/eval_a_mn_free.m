function a_0n_free = eval_a_0n_free(pot_3D)

ampli = get(pot_3D,'ampli').';
omega = get(pot_3D,'omega').';
phase = get(pot_3D,'phase').';
%
a = ampli .* exp(i*phase);
% First order quantities
alpha_m = get(pot_3D,'alpha_n');
mu_n    = get(pot_3D,'mu_n');
n_trsv = length(mu_n);
k_mn    = get(pot_3D,'k_mn');
a_mn    = get(pot_3D,'TF_mn') .* (ones(get(pot_3D,'n_evan')+1,1) * get(pot_3D,'a_0n'));
a_mn    = a_mn * a;
% Second order quantities
beta_m   = get(pot_3D,'beta_m');
gamma_mn = get(pot_3D,'gamma_mn');

M = size(a_mn,1);

% a_0n_free = zeros(1,get(pot_3D,'N_2'));
a_0n_free = zeros(get(pot_3D,'n_vertical_free')+1,get(pot_3D,'n_transverse_free')+1);
for m_prime = 1:get(pot_3D,'n_vertical_free')+1
    beta = beta_m(m_prime);
    tic
    [A_mnpq_p A_mnpq_m] = calc_A_mnpq(a_mn, k_mn, omega, mu_n, beta, alpha_m);
    toc
    for n_prime = 1:pot_3D.n_transverse_free+1
        eps     = mod(n_prime,2);       % eps = 1 if n' is even, 0 else (remember that n'=n_prime-1)
        N_prime = floor((n_prime-1)/2); % (remember that n'=n_prime-1)
        A       = zeros(M,M,max(1,N_prime - eps + 1));
        for n = 1:max(1,N_prime - eps + 1)
            A(:,:,n) = A_mnpq_p(:,n,:,n_prime-n+1);
        end
        result = squeeze(sum(sum(sum(A,1),2),3));
        %
        result = result + eps/2 * sum(sum(squeeze(A_mnpq_p(:,N_prime+1,:,n_prime-N_prime))));
        %
        A      = zeros(M,M,n_trsv - n_prime + 1);
        for n = 1:n_trsv - n_prime + 1
            A(:,:,n) = A_mnpq_m(:,n,:,n_prime+n-1);
        end
        result = result + squeeze(sum(sum(sum(A,1),2),3));
        %
        result = result * (exp(beta) + exp(-beta))^2 / (2*beta + (exp(2*beta) - exp(-2*beta)) / 2) * ...
            beta / gamma_mn(m_prime, n_prime);
        a_0n_free(m_prime,n_prime) = 1/2 * result;
    end
end


function [A_mnpq_p A_mnpq_m] = calc_A_mnpq(a_mn, k_mn, omega, mu_n, beta_m, alpha_m)
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


