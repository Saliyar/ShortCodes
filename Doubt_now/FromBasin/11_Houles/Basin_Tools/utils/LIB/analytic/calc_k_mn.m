function k_mn = calc_k_mn(alpha_m, mu_n)
% k_mn = calc_k_mn(alpha_m, mu_n)
% k_mn = sqrt( alpha_m^2 - mu_n^2 )
%
m       = length(alpha_m);
alpha_m = make_it_column(alpha_m);
n       = length(mu_n);
mu_n    = make_it_row(mu_n);
k_mn    = sqrt((alpha_m .* alpha_m) * ones(1,n) - ones(m,1) * (mu_n .* mu_n));
%
k_mn(real(k_mn) == 0) = - i * abs(k_mn(real(k_mn) == 0));
