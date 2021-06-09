function harmonic = convert2nondim(harmonic, depth)
% harmonic = convert2nondim(harmonic, depth)
% @HARMONIC/CONVERT2NONDIM convert the harmonic object to a nondimensional
% version with respect to depth and gravity acceleration (so that depth=1 and gravity=1 after conversion).
% Input:
%   harmonic is an harmonic object in dimensional form
%   depth    is the depth in the dimensional object to be converted
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if harmonic.dim == 0
    warning('convert2nondim:allready', 'harmonic object already in nondimensional form')
    return
end
% Length scale
x_scale = depth;
% Conversion
harmonic = set(harmonic, 'amplitude', get(harmonic, 'amplitude') / x_scale);
% 
harmonic.dim = 0;
