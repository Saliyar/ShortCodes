function harmonic_out = plus(harmonic1,harmonic2)
% harmonic_out = plus(harmonic1,harmonic2)
% @HARMONIC/PLUS Implement the + operator for two harmonic objects
%   harmonic1 and harmonic2 are objects from harmonic class (cf. help harmonic)
%
harmonic1 = harmonic(harmonic1);
harmonic2 = harmonic(harmonic2);
%
if (~isempty(harmonic1) && ~isempty(harmonic2)) && harmonic1.dim ~= harmonic2.dim
    error('can''t add two waves objects with different dimensional property')
end
%
harmonic_out = harmonic();
harmonic_out = set(harmonic_out, 'harmo',     [[harmonic1.harmo] [harmonic2.harmo]]);
harmonic_out = set(harmonic_out, 'amplitude', [[harmonic1.ampli] [harmonic2.ampli]]);
harmonic_out = set(harmonic_out, 'phase',     [[harmonic1.phase] [harmonic2.phase]]);
harmonic_out = set(harmonic_out, 'angle',     [[harmonic1.angle] [harmonic2.angle]]);
%
harmonic_out.dim = harmonic1.dim;
