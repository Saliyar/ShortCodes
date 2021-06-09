function [p_n, q_n] = calc_pn_qn(alpha_n, I, J_n)
% checking
% if size(alpha_n,2)==1
%     alpha_n = alpha_n.';
% end
alpha_n = make_it_row(alpha_n);
%
if ~isreal(alpha_n) % complex input (alpha_n n>0 are pure imaginaries)
    alpha = abs(alpha_n);
else % real input
    alpha = alpha_n;
end
% evanescent modes
n_evan            = length(alpha)-1;
tan_an            = tan(alpha(2:n_evan+1));
J23oI23(1:n_evan) = (J_n(:,2) + J_n(:,3)).' ./ (I(2) + I(3));
%  for b_1
p_n = I(4) * tan_an ./ J_n(:,1).' .* (J_n(:,4).' ./ I(4) - J23oI23);
%  for a
q_n = I(1) ./ J_n(:,1).' .* tan_an ./ tanh(alpha(1)) .* J23oI23;
