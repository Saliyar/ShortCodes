function S = ITTC_ocean(f, f_p, H_s)
%LIB\WAVE_SPECTRA\ITTC_OCEAN evaluates the ITTC spectrum as
%it is defined in the file "spectra.inc" in the ocean library (edesign \lib
%directory)
% S = ITTC_OCEAN(f, f_p, H_s)
% Input arguments (no default values)
% f     frequency vector in Hz
% f_p   peak frequency in Hz
% H_s   significant wave height in m
%
% See also S_generic, jonswap_ocean, pm_ocean, bretsch_ocean, unified_ocean, ISSC_ocean
%
S = unified_ocean(f, 1.25, f_p, H_s);

