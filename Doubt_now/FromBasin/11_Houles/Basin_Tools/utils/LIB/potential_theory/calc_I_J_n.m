function [I, J_n] = calc_I_J_n(alpha_n, d, D, useless)
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
% A special treatment is made for evanescent integrals with a piston wavemaker
% for which d is set to -infinity

%% progressive mode
k   = alpha_n(1);
chk = cosh(k);
shk = sinh(k);
I(1) = (2*k + sinh(2*k))/(4 * k * chk^2);
if nargin < 3
    D = 0;
end
if D == 0 % monoflap case (upper flap)
    I(2) = 0;
else
    I(2) = (k*D*sinh(k*(d+D)) - cosh(k*(d+D)) + cosh(k*d)) / (k^2 * D * chk);
end
I(3) = (shk - sinh(k*(d+D)))/(k * chk);
if d+D == 1 % monoflap (if D~=0 -> lower flap) or noflap case (D==0)
    I(4) = 0;
elseif d < 0 % monoflap with hinge below bottom floor
    I(4) = (k*(1-d)*shk + 1 - chk) / (k^2 * (1-d) * chk);
else
    I(4) = (k*(1-d-D)*shk + cosh(k*(d+D)) - chk) / (k^2 * (1-d-D) * chk);
end
% Useless 
if nargin > 3
    if d == 1 % noflap case
        I(5) = 0;
    else
        I(5) = (k*(1-d)*shk + cosh(k*d) - chk) / (k^2 * (1-d) * chk);
    end
    I(6) = (sinh(k*(d+D)) - sinh(k*d))/(k * chk);
    I(7) = (I(2)+I(3)) / I(4);
end
%
%% evanescent modes
% checking
n    = 1:length(alpha_n)-1;
al_n = make_it_column(alpha_n(n+1)); % keeping only the evanescent wave_numbers
al_n = abs(al_n); % dealing with complex input (alpha_n n>0 are pure imaginaries)
%
cosan    = cos(al_n);
sinan    = sin(al_n);
J_n(n,1) = (2*al_n + sin(2*al_n)) ./ (4 .* al_n .* cosan.^2);
if D == 0 % monoflap case (upper flap)
    J_n(n,2) = 0;
else
    J_n(n,2) = (al_n.*D.*sin(al_n*(d+D)) + cos(al_n*(d+D)) - cos(al_n*d)) ./ (al_n.^2*D .* cosan);
end
if d == -Inf    % this is the piston case
    J_n(n,3) = 0;
else
    J_n(n,3) = (sinan - sin(al_n*(d+D))) ./ (al_n .* cosan);
end
if d == -Inf    % this is the piston case
    J_n(n,4) = sinan ./ (al_n .* cosan);
elseif d+D == 1 % monoflap (if D~=0 -> lower flap) or noflap case (D==0)
    J_n(n,4) = 0;
elseif d < 0 % monoflap with hinge below bottom floor
    J_n(n,4) = (al_n.*(1-d).*sinan + cosan - 1) ./ (al_n.^2 .* (1-d) .* cosan);
else
    J_n(n,4) = (al_n.*(1-d-D).*sinan + cosan - cos(al_n*(d+D))) ./ (al_n.^2 .* (1-d-D) .* cosan);
end
% Useless 
if nargin > 3
    if d == 1 % noflap case
        J_n(n,5) = 0;
    else
        J_n(n,5) = (al_n.*(1-d).*sinan + cosan - cos(al_n*d)) ./ (al_n.^2 * (1-d) .* cosan);
    end
    J_n(n,6) = (sin(al_n*(d+D)) - sin(al_n*(d))) ./ (al_n .* cosan);
end