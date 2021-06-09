function s = set(s,varargin)
% s = set(s,varargin)
% HARMONIC/SET Set an harmonic property.
%
%   SET(H) displays all property names of an harmonic object H.
%
%   SET(H,'PropertyName',Value) sets the property 'PropertyName' to the
%   corresponding value. Settable property are: harmo, amplitude, phase and angle
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, get, plus, display, rotate, times, convert2nondim,
%    convert2dim, length, isempty, uminus, minus
%
% TODO: display the property names and their possible values in cells for SET(H) ;
% store this structure of cells for V = SET(H).

% Matlab-like behaviour
if nargin == 1
    get(s)
    disp(' ')
    disp('Note that you can not set property dimension: use convert2... instead.')
    disp(' ')
    disp('Also note that you can not set property n_harmo.')
end
%
property_argin = varargin;
while length(property_argin) >= 2,
    prop  = property_argin{1};
    val   = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'dim', 'dimension'}
            error(['can''t set harmonic object dimensional property',...
                'see convert2... instead'])
        case {'size','number','length','n_harmo'}
            error(['can''t set harmonic object number of components, '...
                    'see harmonic/length'])
        case {'harmo','amplitude','ampli','phase','angle','direction','harmonic'}
            % adjusting the number of components
            changed   = (s.n_harmo == length(val));
            s.n_harmo = length(val);
            % setting the specified value and adjusting the other harmonic
            % components
            switch prop
                case {'harmo','harmonic'}
                    s.harmo = complete_vector(make_it_row(val),s.n_harmo);
                    if changed
                        s.ampli = complete_vector(make_it_row(get(s,'amplitude')),s.n_harmo);
                        s.phase = complete_vector(make_it_row(get(s,'phase')),s.n_harmo);
                        s.angle = complete_vector(make_it_row(get(s,'angle')),s.n_harmo);
                    end
                case {'amplitude','ampli'}
                    s.ampli = complete_vector(make_it_row(val),s.n_harmo);
                    if changed
                        s.harmo = complete_vector(make_it_row(get(s,'harmo')),s.n_harmo);
                        s.phase = complete_vector(make_it_row(get(s,'phase')),s.n_harmo);
                        s.angle = complete_vector(make_it_row(get(s,'angle')),s.n_harmo);
                    end
                case 'phase'
                    s.phase = complete_vector(make_it_row(val),s.n_harmo);
                    if changed
                        s.harmo = complete_vector(make_it_row(get(s,'harmo')),s.n_harmo);
                        s.ampli = complete_vector(make_it_row(get(s,'amplitude')),s.n_harmo);
                        s.angle = complete_vector(make_it_row(get(s,'angle')),s.n_harmo);
                    end
                case {'angle','direction'}
                    s.angle = complete_vector(make_it_row(val),s.n_harmo);
                    if changed
                        s.harmo = complete_vector(make_it_row(get(s,'harmo')),s.n_harmo);
                        s.ampli = complete_vector(make_it_row(get(s,'amplitude')),s.n_harmo);
                        s.phase = complete_vector(make_it_row(get(s,'phase')),s.n_harmo);
                    end
            end
        otherwise
            error([prop ,' is not a valid harmonic property. Harmonic properties: harmo, amplitude, phase and angle'])
    end
end
