function B_mn = calc_B_mn(omega, alpha_n, TF_n)
%
alpha_m     = make_it_column(alpha_n) * ones(1,length(alpha_n));
alpha_n_bar = ones(length(alpha_n),1) * conj(make_it_row(alpha_n));
TF_n        = make_it_row(TF_n);
B_mn        = - (TF_n.' * conj(TF_n)) ./ (2*omega^3) .* (alpha_m + alpha_n_bar) ...
                ./ (alpha_m - alpha_n_bar) .* (omega^4 - alpha_m .* alpha_n_bar);
B_mn(1,1)   = 0;

B_mn = B_mn / 2; % because it's a self interaction 
% which is half the interaction of it over itself