function s = set(s,varargin)
% s = set(s,varargin)
% @POTENTIAL_3D/SET set potential_3D property to the specified value.
% Inputs:
%   s         is a potential_3D object,
%   varargin  is a set of potential_3D property name and value. Property names are: n_evan, alpha_n, TF, TF_n and any
%             potential_2D property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN, CALC_ETA_LIN
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'n_transverse'}
            s.n_transverse  = val;
        case {'N_1'}
            s.N_1  = val;
        case {'k_mn'}
            s.k_mn  = val;
        case {'k_0n'}
            s.k_0n  = val;
        case {'a_0n'}
            s.a_0n  = val;
        case {'A_0n'}
            s.A_0n  = val;
        case {'mu_n'}
            s.mu_n  = val;
        case {'I_n'}
            s.I_n  = val;
        case {'TF_mn'}
            s.TF_mn  = val;
        case {'potential_2D'}
            s.potential_2D  = val;
        otherwise
            s.potential_2D = set(s.potential_2D, prop, val);
    end
end