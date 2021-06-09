function w = lambda2w(lambda, depth)
% LAMBDA2W Gives the angular frequency from the wavelength.
%   w = LAMBDA2W(lambda) returns the angular frequency omega in adimensionned way. Uses the
%   dispersion relation from linear theory (Airy's theory) for finite
%   depth.
%
%   w = LAMBDA2W(lambda, depth) returns the angular frequency omega in dimensionned way.
%   Uses the dispersion relation from linear theory (Airy's theory) for
%   finite depth 'depth' (lambda and depth in meter, w in radian per second).
%
%   See also lambda2T, lambda2f
if nargin == 1
   tmp = 2.0 * pi / lambda;
   tmp = sqrt(tmp * tanh(tmp) );
elseif nargin == 2
   g   = 9.81;
   tmp = 2.0 * pi / lambda;
   tmp = sqrt(g * tmp * tanh(tmp*depth) );
end
if nargout == 0
    lambda2w = tmp
else
    w = tmp;
end
