function val = get(s,propName)
% val = get(s,propName)
% HARMONIC/GET Get an harmonic object property.
%
%    GET(H) displays all property names of an harmonic object H.
%
%    val = GET(H,'PropertyName') returns the property 'PropertyName'.
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, set, plus, display, rotate, times, convert2nondim,
%    convert2dim, length, isempty, uminus, minus
%
% TODO: display the property names and their values for GET(H) and store
% them in a structure for V = GET(H).

if nargin == 1
    disp('Properties for harmonic objects are:')
    disp('dimension, n_harmo, harmonic, amplitude, phase, angle')
else
    switch propName
        case {'dim', 'dimension'}
            val = s.dim;
        case {'size','number','length','n_harmo'}
            val = s.n_harmo;
        case {'harmo','harmonic'}
            val = s.harmo;
        case {'amplitude', 'Amplitude', 'ampli'}
            val = s.ampli;
        case {'phase', 'Phase'}
            val = s.phase;
        case {'angle','direction','Angle','Direction'}
            val = s.angle;
        otherwise
            error([propName ,' is not a valid harmonic property'])
    end
end