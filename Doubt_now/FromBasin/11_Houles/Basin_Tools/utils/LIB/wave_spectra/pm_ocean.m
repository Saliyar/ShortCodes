function S = pm_ocean(f, f_p, Comp)
%LIB\WAVE_SPECTRA\PM_OCEAN evaluates the Pierson-Moskowitz spectrum as it
%is defined in ocean
% S = PM_OCEAN(f, f_p, Comp)
% Input arguments
% f     frequency vector in Hz
% f_p   peak frequency in Hz
% Comp  compression factor
% Note that I couldn't make it work exactly as in ocean (need to check the
% source files)
%
% See also S_generic, jonswap_ocean, bretsch_ocean, unified_ocean, ITTC_ocean, ISSC_ocean
%
if nargin < 3
    Comp = 1;
elseif isempty(Comp)
    Comp = 1;   
end
%
g       = 9.81;
omega_p = 2 * pi * f_p;
alpha   = 0.0081;
tau     = 0.857222;
f_e     = f_p;% / tau;
%
A = alpha * g^2;
p = 5;
q = 4;
B = 1.25 * omega_p^q;
%
f_prime = f_e ./ (tau + (f_p./f-tau)/Comp);
%
if f == 0.0
    S = 0.0;
else
    S = S_generic(f_prime, A, p, B, q) * 2*pi;
    % the 2pi factor is present because S_generic returns a spectrum S(omega) as a
    % function of omega and S(f) = 2pi S(omega)
end

