function [p_n, p_n_osc, q_n, q_n_osc] = calc_pn_qn_osc(alpha_n, I, J_n, J_n_osc)
% checking
if size(alpha_n,2)==1
    alpha_n = alpha_n.';
end
%
if ~isreal(alpha_n) % complex input (alpha_n n>0 are pure imaginaries)
    alpha = abs(alpha_n);
else % real input
    alpha = alpha_n;
end
% evanescent modes
n_evan            = length(alpha)-1;
tan_an            = tan(alpha(2:n_evan+1));
J23oI23(1:n_evan)     = (J_n(:,2) + J_n(:,3)).' ./ (I(2) + I(3));
J23oI23_osc(1:n_evan,1) = (J_n_osc(:,2,1) + J_n_osc(:,3,1)) ./ (I(2) + I(3));
J23oI23_osc(1:n_evan,2) = (J_n_osc(:,2,2) + J_n_osc(:,3,2)) ./ (I(2) + I(3));
%  for b_1
p_n     = I(4) * tan_an ./ J_n(:,1).' .* (J_n(:,4).' ./ I(4) - J23oI23);
p_n_osc(:,1) = I(4) * tan_an.' ./ J_n(:,1) .* (J_n_osc(:,4,1) ./ I(4) - J23oI23_osc(:,1));
p_n_osc(:,2) = I(4) * tan_an.' ./ J_n(:,1) .* (J_n_osc(:,4,2) ./ I(4) - J23oI23_osc(:,2));
%  for a
q_n     = I(1) ./ J_n(:,1).' .* tan_an ./ tanh(alpha(1)) .* J23oI23;
q_n_osc(:,1) = I(1) ./ J_n(:,1) .* tan_an.' ./ tanh(alpha(1)) .* J23oI23_osc(:,1);
q_n_osc(:,2) = I(1) ./ J_n(:,1) .* tan_an.' ./ tanh(alpha(1)) .* J23oI23_osc(:,2);
