function harmonic_in = times(alpha,harmonic_in)
% harmonic_in = times(alpha,harmonic_in)
% @HARMONIC/TIMES Implement the .* operator for an harmonic object and a scalar
%   harmonic_in is an object from the harmonic class (cf. help harmonic)
%   alpha is a scalar (can be complex)
%
harmonic_in = harmonic(harmonic_in);
% amplitude
harmonic_in = set(harmonic_in, 'amplitude', abs(alpha) .* get(harmonic_in,'amplitude'));
% phase (if alpha is complex)
harmonic_in = set(harmonic_in, 'phase', angle(alpha) + get(harmonic_in,'phase'));
