function [S] = jonswap_ocean(f, f_p, gamma, sigma_a, sigma_b, alpha)
%LIB\WAVE_SPECTRA\JONSWAP_OCEAN reproduces the JONSWAP spectrum as
%ocean does
% S = JONSWAP_OCEAN(f, f_p, gamma, sigma_a, sigma_b, alpha)
% Input arguments
% f         frequency vector in Hz
% f_p       peak frequency in Hz
% gamma     jonswap gamma factor. The default value is 1. gamma=1 gives a Pierson-Moskowitz
% spectrum
% sigma_a   value of sigma for f>f_p (optional). The default value is
% the one given in ocean, sigma_a=0.07 which is uncorrect (should be 0.09)
% sigma_b   value of sigma for f<f_p (optional). The default value is
% the one given in ocean, sigma_b=0.09 which is uncorrect (should be 0.07)
% alpha     Philipps constant (optional). The default value is 8.1e3.
% 
% This means that a correct Jonswap spectrum is obtained when sigma_a and
% sigma_b are explicitly specified, respectively to 0.09 and 0.07.
%
% Note that the order of the two values of sigma is the same than in ocean
%
% The jonswap_beta.m should be used for correct H_s
%
% See also S_generic, bretsch_ocean, pm_ocean, unified_ocean, ITTC_ocean, ISSC_ocean
% jonswap_beta
%

% Dealing with optional arguments and their default values
if nargin < 3
    gamma = 1;
elseif isempty(gamma)
    gamma = 1;
end
%
if nargin < 4
    sigma_a = 0.07;
elseif isempty(sigma_a)
    sigma_a = 0.07;
end
%
if nargin < 5
    sigma_b = 0.09;
elseif isempty(sigma_b)
    sigma_b = 0.09;
end
%
if nargin < 6
    alpha = 0.0081;
elseif isempty(alpha)
    alpha = 0.0081;
end
%
S = pm(f, f_p, alpha);
%
sigma        = ones(size(f)) * sigma_b;
sigma(f>f_p) = sigma_a;
%
a = (f/f_p-1)./sigma;
a = a.^2 / 2;
a = exp( - a);
%
S = S .* gamma.^a;

