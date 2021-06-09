function a_l_mn_indep = calc_a_l_mn_indep(omega, alpha_n, TF_n, sigma_n)
%
n_evanp1    = length(alpha_n);
alpha_n     = make_it_column(alpha_n);
TF_n        = make_it_column(TF_n);
alpha_m     = alpha_n * ones(1,n_evanp1);
alpha_n_bar = ones(n_evanp1,1) * conj(alpha_n.');
%
a_l_mn_indep = (alpha_m + alpha_n_bar) .* (TF_n * conj(TF_n.')) .* ...
                 ((alpha_m + alpha_n_bar).^2 ./ (sigma_n^2 - (alpha_m + alpha_n_bar).^2) ...
                - (alpha_m - alpha_n_bar).^2 ./ (sigma_n^2 - (alpha_m - alpha_n_bar).^2));
% a_l_mn_indep = triu(a_l_mn_indep);
% for n=1:n_evanp1
%     a_l_mn_indep(n,n) = a_l_mn_indep(n,n) / 2;
% end
% a = tril(a_l_mn_indep);
% a(:,1) = 0;
% disp(['???? ' num2str(sum(sum(a)))] )

a_l_mn_indep = sum(sum(a_l_mn_indep));
a_l_mn_indep = a_l_mn_indep * (exp(sigma_n)+exp(-sigma_n))^2 / (2*sigma_n) / (2*omega);

a_l_mn_indep = a_l_mn_indep / 2; % because it's a self interaction 
% which is half the interaction of 1 over 2=1
% disp(['good ' num2str(a_l_mn_indep)] )
% a_l_mn_indep = i * imag(a_l_mn_indep);