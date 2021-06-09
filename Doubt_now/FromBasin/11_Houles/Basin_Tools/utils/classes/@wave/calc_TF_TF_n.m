function [TF, TF_n] = calc_TF_TF_n(wv, alpha_n)
% [TF, TF_n] = calc_TF_TF_n(wv, alpha_n)
% @WAVE\CALC_TF_TF_N  evaluates the 2D transfer function for progressive
% and evanescent modes
% Input:
%   wv is a wave object
%   alpha_n is a vector of the wave numbers
%
TF_type = get(wv, 'TF_type');
d = get(wv, 'hinge_bottom');
D = get(wv, 'middle_flap');
%
[I, J_n] = calc_I_J_n(alpha_n, d, D);
%
% Transfer functions
if strcmp(TF_type,'biflap') && TF_type > 3
    [p_n, q_n] = calc_pn_qn(alpha_n, I, J_n);
    D_mn       = calc_D_mn(alpha_n, get(wv,'omega'));
    TF         = TF_wmk(wv, I, p_n, q_n, D_mn);
else
    TF         = TF_wmk(wv);
end
%
TF_n = calc_TF_n(alpha_n, TF, J_n);