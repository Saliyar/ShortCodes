function TF = build_TF_B600_5_1(k, I, p_n, q_n)
% 
% Required values
thkh       = tanh(k);
%
% Transfer function upper flap b_1 / a
TF(1) = i * sum(q_n)/sum(p_n);
% Transfer function lower flap b_2 / a
TF(2) = - (i * I(1)/thkh + TF(1) * I(4)) / (I(2) + I(3));
