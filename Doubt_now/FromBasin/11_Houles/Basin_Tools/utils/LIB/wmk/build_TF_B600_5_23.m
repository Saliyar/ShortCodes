function TF = build_TF_B600_5_23(k, type, I, p_n, q_n, D_mn)
% parameter
n_evan = length(p_n);
%
% Required values
thkh              = tanh(k);
%
% Polynomial in b_1/a (second order)
% constant term
p(3) = D_mn(1,1) - 2 * i * sum(D_mn(1,2:n_evan+1) .* q_n) - sum(sum(D_mn(2:n_evan+1,2:n_evan+1) .* (q_n.'*q_n)));
% first order term
p(2) = 2 * sum(D_mn(1,2:n_evan+1) .* p_n) - i * sum(sum(D_mn(2:n_evan+1,2:n_evan+1) .* (q_n.'*p_n + p_n.'*q_n)));
% second order term
p(1) = sum(sum(D_mn(2:n_evan+1,2:n_evan+1) .* (p_n.'*p_n)));
% roots
r = roots(p);
% Transfer function upper flap b_1 / a
TF_bi(1,:) = r.';
% Transfer function lower flap b_2 / a
TF_bi(2,:) = - (i * I(1)/thkh + TF_bi(1,:) * I(4)) / (I(2) + I(3));
if abs(imag(TF_bi(2,1))) < abs(imag(TF_bi(2,2)))
    temp = TF_bi(2,2);
    TF_bi(2,2) = TF_bi(2,1);
    TF_bi(2,1) = temp;
    temp = TF_bi(1,2);
    TF_bi(1,2) = TF_bi(1,1);
    TF_bi(1,1) = temp;
end
% Choice between types 5.2 and 5.3
if type == 5.3
    TF(1) = TF_bi(1,1);
    TF(2) = TF_bi(2,1);
elseif type == 5.2
    TF(1) = TF_bi(1,2);
    TF(2) = TF_bi(2,2);
end
