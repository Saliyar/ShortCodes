function S = ISSC_ocean(f, f_mean, H_s)
%LIB\WAVE_SPECTRA\ISSC_OCEAN evaluates the ISSC spectrum as
%it is defined in the file "spectra.inc" in the ocean library (edesign \lib
%directory)
% S = ISSC_OCEAN(f, f_mean, H_s)
% Input arguments (no default values)
% f         frequency vector in Hz
% f_mean    mean frequency in Hz
% H_s       significant wave height in m
%
% See also S_generic, jonswap_ocean, pm_ocean, bretsch_ocean, unified_ocean, ITTC_ocean
%
%
S = unified_ocean(f, 0.4427, f_mean, H_s);

