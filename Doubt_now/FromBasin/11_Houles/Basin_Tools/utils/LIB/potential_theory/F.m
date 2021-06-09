function F_pm = F(pm, alpha, z)
% F_pm = F(pm, alpha, z)
% LIB\ANALYTIC\F evaluates the function F^\pm(alpha,z)
% Inputs:
%   pm is +1 or -1
%   alpha is the wavenumber
%   z is the non-dimensional vertical position, positive upwards with
%   reference at the mean water level. The bottom is located at z=-1.
%
F_pm = (exp(alpha*(z+1)) + pm * exp(-alpha*(z+1))) ./ (exp(alpha) + exp(-alpha));

