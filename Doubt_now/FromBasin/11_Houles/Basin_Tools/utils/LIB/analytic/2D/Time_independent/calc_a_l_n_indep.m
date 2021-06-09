function a_l_n_indep = calc_a_l_n_indep(omega, alpha_n, TF_n, sigma_n)
%
alpha_0     = alpha_n(1);
evan        = 2:length(alpha_n);
%
a_l_n_indep = 2 * sum(build_matrix(alpha_0, alpha_n(evan), 1, TF_n(evan), sigma_n));
a_l_n_indep = a_l_n_indep + build_matrix(alpha_0, alpha_0, 1, 1, sigma_n);
a_l_n_indep = a_l_n_indep * (exp(sigma_n)+exp(-sigma_n))^2 / (2*sigma_n) / (4*omega);

function y = build_matrix(alpha_m, alpha_n, TF_m, TF_n, sigma)
N_m = length(alpha_m);
N_n = length(alpha_n);
alpha_m = make_it_column(alpha_m) * ones(1,N_n);
alpha_n = ones(N_m,1) * conj(make_it_row(alpha_n));
TF_m    = make_it_column(TF_m);
TF_n    = make_it_row(TF_n);
y = (alpha_m + alpha_n) .* (TF_m * conj(TF_n)) .* ...
                 ((alpha_m + alpha_n).^2./(sigma^2 - (alpha_m + alpha_n).^2) ...
                - (alpha_m - alpha_n).^2./(sigma^2 - (alpha_m - alpha_n).^2));