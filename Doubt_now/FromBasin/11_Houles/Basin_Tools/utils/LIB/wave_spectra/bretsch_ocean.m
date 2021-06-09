function S = bretsch_ocean(f, f_p, m_0)
%LIB\WAVE_SPECTRA\BRETSCH_OCEAN evaluates the Bretschneider spectrum as
%ocean does
% S = BRETSCH_OCEAN(f, f_p, m_0)
% Input arguments (no default values)
% f     frequency vector in Hz
% f_p   peak frequency in Hz
% m_0   0th order moment of the spectrum in m^2 (m_0 = Hs^2/16)
%
% Expression is S(f)=5m_0*f_p^4/f^5*exp(-1.25*(f_p/f)^4)
%
% See also S_generic, jonswap_ocean, pm_ocean, unified_ocean, ITTC_ocean, ISSC_ocean
%
omega_p = 2 * pi * f_p;
%
A = 5 * m_0 * omega_p^4;
p = 5;
q = 4;
B = 1.25 * omega_p^q;
%
S = 2 * pi * S_generic(f, A, p, B, q);
% the 2pi factor is present because S_generic returns a spectrum S(omega) as a
% function of omega and S(f) = 2pi S(omega)

