function TF = build_TF_B600_5_4(k, I, p_n, q_n, D_mn)
% parameter
n_evan = length(p_n);
%
% Required values
thkh              = tanh(k);
%
% Transfer function upper flap b_1 / a
TF(1) = i * (sum(sum(D_mn(2:n_evan+1,2:n_evan+1) .* (q_n.'*p_n))) + i * sum(D_mn(1,2:n_evan+1) .* p_n)) / ...
             sum(sum(D_mn(2:n_evan+1,2:n_evan+1) .* (p_n.'*p_n)));
% Transfer function lower flap b_2 / a
TF(2) = - (i * I(1)/thkh + TF(1) * I(4)) / (I(2) + I(3));
