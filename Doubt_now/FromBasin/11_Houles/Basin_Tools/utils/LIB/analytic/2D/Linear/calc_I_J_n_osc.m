function [I, J_n, J_n_osc] = calc_I_J_n_osc(alpha_n, d, D)
% [I, J_n] = calc_I_J_n(alpha_n, d, D)
% Inputs (all in adim version)
%   alpha_n vector of wavenumbers of size n_evan+1
%   (alpha(1)=k is the progressive one and alpha_n(n) n>1 are the evanescent ones) 
%   d bottom hinge height (measured from bottom)
%   D lower flap size
% Output
%   I(n) n=1..5 the I integrals
%   J_n(n,m) n=1..n_evan, m=1..4 the J^n integrals
%

% checking
if D==0
    disp 'Single flap not implemented correctly in 2D/calc_TF_n'
    return
end
if ~isreal(alpha_n) % complex input (alpha_n n>0 are pure imaginaries)
    alpha = abs(alpha_n);
else % real input
    alpha = alpha_n;
end
% progressive mode
k   = alpha(1);
chk = cosh(k);
I(1) = (2*k + sinh(2*k))/(4 * k * chk^2);
I(2) = (k*D*sinh(k*(d+D)) - cosh(k*(d+D)) + cosh(k*d)) / (k^2 * D * chk);
I(3) = (sinh(k) - sinh(k*(d+D)))/(k * chk);
I(4) = (k*(1-d-D)*sinh(k) + cosh(k*(d+D)) - chk) / (k^2 * (1-d-D) * chk);
I(5) = (k*sinh(k) + 1 - chk)/(k^2 * chk);
I(6) = (sinh(k*(d+D)) - sinh(k*d))/(k * chk);
I(7) = (I(2)+I(3)) / I(4);
% evanescent modes
n          = (2:length(alpha)).';
al_n       = alpha(n).';
cosan      = cos(al_n);
J_n(n-1,1)     = (2*al_n + sin(2*al_n)) ./ (4 .* al_n .* cosan.^2);
% J_2^n without the alpha_n D sin alpha_n (d+D)
J_n_osc(n-1,2,1) = - cos(al_n*d) ./ (al_n.^2*D .* cosan);
J_n_osc(n-1,2,2) =  cos(al_n*(d+D)) ./ (al_n.^2*D .* cosan);
J_n(n-1,3)     = sin(al_n) ./ (al_n .* cosan);
% J_3^n without the alpha_n D sin alpha_n (d+D)
J_n_osc(n-1,3,1) = 0;
J_n_osc(n-1,3,2) = 0;
J_n(n-1,4)     = (al_n.*(1-d-D).*sin(al_n) + cosan) ./ (al_n.^2 .* (1-d-D) .* cosan);
J_n_osc(n-1,4,2) = - cos(al_n*(d+D)) ./ (al_n.^2 .* (1-d-D) .* cosan);
J_n(n-1,6)     = (sin(al_n*(d+D)) - sin(al_n*(d))) ./ (al_n .* cos(al_n));
