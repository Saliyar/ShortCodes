function S = jonswap(f, f_p, m_0, gamma)
%LIB\WAVE_SPECTRA\JONSWAP evaluates the jonswap spectra
% at requested frequencies f in Hz
% S = JONSWAP_OCEAN(f, f_p, m_0, gamma)
% Input arguments
% f         frequency vector in Hz
% f_p       peak frequency in Hz
% m_0       0th order moment of the spectrum in m^2 (m_0 = Hs^2/16)
% gamma     jonswap gamma factor. The default value is 1. gamma=1 gives a Pierson-Moskowitz
% spectrum
%
S = 16 / 5 * bretsch_ocean(f, f_p, m_0);
%
sigma = 0.07 * ones(size(f));
sigma(f >= f_p) = 0.09;
%
a = exp(-(f-f_p).^2./(2*sigma.^2*f_p^2));
%
S = S .* gamma.^a;
%
% numerical integration
freq  = (1:3000)*0.001;
S2    = 16 / 5 * bretsch_ocean(freq, f_p, m_0);
sigma = 0.07 * ones(size(freq));
sigma(freq >= f_p) = 0.09;
%
a  = exp(-(freq-f_p).^2./(2*sigma.^2*f_p^2));
%
S2 = S2 .* gamma.^a;
Int_S2df = sum(S2) * (freq(2)-freq(1));
alpha = m_0 / Int_S2df;
%
S = S * alpha;


