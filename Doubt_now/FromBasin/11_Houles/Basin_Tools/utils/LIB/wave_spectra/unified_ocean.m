function S = unified_ocean(f, A, f_char, H_s)
%LIB\WAVE_SPECTRA\UNIFIED_OCEAN evaluates the unified spectrum as
%it is defined in the file "spectra.inc" in the ocean library (edesign \lib
%directory)
% S = UNIFIED_OCEAN(f, A, f_char, H_s)
% Input arguments (no default values)
% f         frequency vector in Hz
% A         coefficient
% f_char    characteristic frequency in Hz
% H_s       significant wave height in m
%
% See also S_generic, jonswap_ocean, pm_ocean, bretsch_ocean, ITTC_ocean, ISSC_ocean
%
%
S = bretsch_ocean(f, f_char * (0.8*A)^(0.25), H_s^2/16);

