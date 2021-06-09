function harmonic = mtimes(alpha,harmonic)
% harmonic = mtimes(alpha,harmonic)
% @HARMONIC/MTIMES Implement the * operator for an harmonic object and a scalar
%   harmonic is an object from the harmonic class (cf. help harmonic)
%   alpha is a scalar (can be complex)
%
harmonic = times(alpha,harmonic);
% we define mtimes so that writing alpha * wave is enough. Without this, we
% would have to write alpha .* wave (function times)
