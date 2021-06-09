function s = set(s,varargin)
% s = set(s,varargin)
% @WAVED/SET set wave property to the specified value.
% Inputs:
%   s         is a wave object,
%   varargin  is a set of wave property name and value. Property names are: TF_type, f_samp, n_repeat, harmo, amplitude, phase, angle and any
%             wave and wavemaker property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'TF_type','TF'}
            if ~strcmp(get(s,'type'), 'biflap')
                if ~(strcmp(get(s,'type'),'hinged') || strcmp(get(s,'type'),'monoflap') || strcmp(get(s,'type'),'piston') || strcmp(get(s,'type'),'piston_step'))
                    error('Unknown type of transfer function type for non-biflap wavemaker')
                end
            elseif val < 0 || val > 6
                error('The biflap transfer function type must be between 0 and 6')
            else
                s.TF_type  = val;
            end
        case 'f_samp'
            s.f_samp  = val;
        case 'n_repeat'
            s.n_repeat  = val;
        case {'wave', 'data', 'harmonic'}
            s.harmonic = val;
%             FIXME: strange if you use set(gcw,'harmo',harmonic(32,0.1))
        case 'control_law'
            s.control_law = val;
        case {'harmo','amplitude','ampli','phase','angle'}
            s.harmonic = set(s.harmonic, prop, val);
        case 'wavemaker'
            s.wavemaker = val;
        case {'depth', 'type', 'hinge_bottom', 'middle_flap', 'type_ramp', 'ramp', 'Ly'}
            s.wavemaker = set(s.wavemaker, prop, val);
        otherwise
            error([prop ,' is not a valid wave property. Wave properties: n_repeat and every wave or wavemaker properties'])
    end
end
