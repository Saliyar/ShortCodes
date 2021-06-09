function S = pm(f, f_p, alpha)
%LIB\WAVE_SPECTRA\PM Pierson-Moskowitz spectrum S(f) as a function of
%frequency
% S = PM(f, f_p, alpha)
% Input arguments
% f         frequency vector in Hz
% f_p       peak frequency in Hz
% gamma     Philipps constant, default value 8.1e3 (optional)
%
% See also S_generic, jonswap_ocean, pm_ocean, bretsch_ocean, ITTC_ocean,
% ISSC_ocean, unified_ocean
%

% Dealing with optional argument and its default value
if nargin < 3
    alpha = 0.0081;
elseif isempty(alpha)
    alpha = 0.0081;
end
g       = 9.81;
omega_p = 2 * pi * f_p;
%
A = alpha * g^2;
p = 5;
q = 4;
B = 1.25 * omega_p^q;
%
if f == 0.0
    S = 0.0;
else
    S = S_generic(f, A, p, B, q) * 2 * pi;
    % the 2pi factor is present because S_generic returns a spectrum S(omega) as a
    % function of omega and S(f) = 2pi S(omega)
end
