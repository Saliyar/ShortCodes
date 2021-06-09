function val = get(s,propName)
% WAVEMAKER/GET Get wavemaker property from the specified object and return the value.
% Property names are: dim, depth, type, hinge_bottom, middle_flap, n_paddles, Ly, type_ramp,
% and ramp
switch propName
    case  {'dim', 'dimension'}
        val = s.dim;
    case 'depth'
        val = s.depth;
    case 'type'
        val = s.type;
    case 'hinge_bottom'
        val = s.hinge_bottom;
    case 'middle_flap'
        val = s.middle_flap;
    case 'n_paddles'
        val = s.n_paddles;
    case {'Ly', 'L_y'}
        val = s.Ly;
    case 'type'
        val = s.type;
    case 'type_ramp'
        val = s.type_ramp;
    case 'ramp'
        val = s.ramp;
    otherwise
        error('Wrong Property name')
end
