function harmonic_in = rotate(harmonic_in, theta)
% harmonic_in = rotate(harmonic_in, theta)
% @HARMONIC/ROTATE rotates the harmonic harmonic_in of an angle theta
%   * harmonic_in is an object from harmonic class (cf. help harmonic)
%   * theta is a scalar
%
harmonic_in = harmonic(harmonic_in);
% angle
harmonic_in = set(harmonic_in, 'angle', theta + get(harmonic_in,'angle'));
