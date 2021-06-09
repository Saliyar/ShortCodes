function k = kfromw(omega, depth, g)
%
% kfromw gives the wave number at given pulsation 'omega' and depth
% through first order dispersion relation.
%
% depth is water depth (in m) and g the gravity acceleration
%
% k = kfromw(omega, depth, g)
%
rhs = (omega).^2;
k = fzero(@(k) disp_relation(k,rhs,g,depth),rhs);
%
%
%
function y = disp_relation(k,rhs,g,depth)
%
y = g*k .* tanh(k*depth) - rhs;