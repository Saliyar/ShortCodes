function harmonic = convert2dim(harmonic, depth)
% harmonic = convert2dim(harmonic, depth)
% @HARMONIC/CONVERT2DIM convert the harmonic object to a dimensional version
% with respect to depth and gravity acceleration
% Inputs:
%   harmonic is an harmonic object in nondimensional form (depth=1 and gravity=1)
%   depth    is the new depth in the dimensional object to be created
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if harmonic.dim == 1
    warning('convert2dim:allready', 'harmonic object already in dimensional form')
    return
end
% Length scale
x_scale = depth;
% Conversion
harmonic = set(harmonic, 'amplitude', get(harmonic, 'amplitude') * x_scale);
% 
harmonic.dim = 1;
