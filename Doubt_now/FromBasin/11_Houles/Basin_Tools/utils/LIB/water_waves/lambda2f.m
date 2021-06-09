function f = lambda2f(lambda, depth)
% LAMBDA2F Gives the frequency from the wavelength.
%   f = LAMBDA2F(lambda) returns the frequency f in adimensionned way. Uses the
%   dispersion relation from linear theory (Airy's theory) for finite
%   depth.
%
%   f = LAMBDA2F(lambda, depth) returns the frequency f in dimensionned way.
%   Uses the dispersion relation from linear theory (Airy's theory) for
%   finite depth 'depth' (lambda and depth in meter, f in Hz).
%
%   See also lambda2w, lambda2T
if nargin == 1
   tmp = lambda2w(lambda) / (2 * pi);
elseif nargin == 2
   tmp = lambda2w(lambda, depth) / (2 * pi);
end
if nargout == 0
    lambda2f = tmp
else
    f = tmp;
end
