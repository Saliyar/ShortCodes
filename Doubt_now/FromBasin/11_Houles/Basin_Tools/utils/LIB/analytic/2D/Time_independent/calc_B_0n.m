function B_0n = calc_B_0n(omega, alpha_n, TF_n)
%
alpha_0     = alpha_n(1);
evan        = 1:length(alpha_n);
alpha_m_bar = conj(alpha_n(evan));
B_0n        = - conj(TF_n(evan)) / (2*omega^3) .* (alpha_0 + alpha_m_bar) ./ (alpha_0 - alpha_m_bar) .* ...
                (omega^4 - alpha_0 * alpha_m_bar);