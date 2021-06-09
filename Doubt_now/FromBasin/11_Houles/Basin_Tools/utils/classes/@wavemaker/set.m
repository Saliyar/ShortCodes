function s = set(s,varargin)
% WAVEMAKER/SET Set wavemaker property to the specified value.
% Property names are: depth, type, hinge_bottom, middle_flap, n_paddles, Ly, type_ramp and ramp
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'dim', 'dimension'}
            error('can''t set wavemaker object dimensional property')
        case 'depth'
            s.depth = val;
        case 'type'
            s.type = val;
        case 'hinge_bottom'
            s.hinge_bottom = val;
        case 'middle_flap'
            s.middle_flap = val;
        case 'n_paddles'
            s.n_paddles = val;
        case {'Ly', 'L_y'}
            s.Ly = val;
        case 'type_ramp'
            s.type_ramp = val;
        case 'ramp'
            s.ramp = val;
        otherwise
            error([prop ,' is not a valid wavemaker property. Wavemaker properties: depth, type, hinge_bottom, middle_flap, n_paddles, Ly, type_ramp and ramp'])
    end
end
