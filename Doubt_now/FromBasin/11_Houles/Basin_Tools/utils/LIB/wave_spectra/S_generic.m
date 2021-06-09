function S = S_generic(f, A, p, B, q)
%LIB\WAVE_SPECTRA\S_GENERIC evaluates a generic spectrum S(omega)
% S = S_GENERIC(f, A, p, B, q)
% Input arguments (no default values)
% f     frequency vector in Hz
% A, B  constants
% p, q  exponents
% Expression is S(omega) = A * omega.^(-p) .* exp(- B * omega.^(-q))
%
% See also jonswap_ocean, bretsch_ocean, pm_ocean, unified_ocean, ITTC_ocean, ISSC_ocean
%
omega     = 2 * pi * f;
S         = A * omega.^(-p) .* exp(- B * omega.^(-q));
S(f<1e-8) = 0;
