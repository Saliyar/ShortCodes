function s = set(s,varargin)
% s = set(s,varargin)
% @POTENTIAL_2D/SET set potential_2D property to the specified value.
% Inputs:
%   s         is a potential_2D object,
%   varargin  is a set of potential_2D property name and value. Property names are: n_evan, alpha_n, TF, TF_n and any
%             wave property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'n_evan', 'evanescent'}
            s.n_evan  = val;
        case {'n_evan_free'}
            s.n_evan_free  = val;
        case {'alpha_n'}
            s.alpha_n  = val;
        case {'TF'}
            s.TF  = val;
        case {'TF_n'}
            s.TF_n  = val;
        case {'wave'}
            s.wave  = val;
            s       = init_data_2D(s);
        case {'free'}
            s.free  = val;
        otherwise
            s.wave = set(s.wave, prop, val);
            s      = init_data_2D(s);
    end
end