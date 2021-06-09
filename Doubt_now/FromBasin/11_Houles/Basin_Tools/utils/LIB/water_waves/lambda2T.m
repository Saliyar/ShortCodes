function t = lambda2T(lambda, depth)
% LAMBDA2T Gives the angular frequency from the wavelength.
%   t = LAMBDA2T(lambda) returns the wave period T in adimensionned way. Uses the
%   dispersion relation from linear theory (Airy's theory) for finite
%   depth.
%
%   t = LAMBDA2T(lambda, depth) returns the wave period T in dimensionned way.
%   Uses the dispersion relation from linear theory (Airy's theory) for
%   finite depth 'depth' (lambda and depth in meter, t in second).
%
%   See also lambda2w, lambda2f
if nargin == 1
   tmp = 2 * pi / lambda2w(lambda);
elseif nargin == 2
   tmp = 2 * pi / lambda2w(lambda, depth);
end
if nargout == 0
    lambda2T = tmp
else
    t = tmp;
end
