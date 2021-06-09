function TF_mn = calc_TF_mn(k_mn, k_0n, alpha_m, k, TF_m)
% TF_mn = calc_TF_mn(k_mn, k_0n, alpha_m, k, TF_m)
%
m       = size(k_mn, 1);
n       = size(k_mn, 2);
alpha_m = make_it_column(alpha_m);
TF_m    = make_it_column(TF_m);
TF_mn   = (ones(m,1) * k_0n) ./ k_mn .* ((alpha_m  ./ k .* TF_m) * ones(1,n));
