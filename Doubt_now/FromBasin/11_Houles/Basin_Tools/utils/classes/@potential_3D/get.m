function val = get(s,propName)
% val = get(s,propName)
% @POTENTIAL_3D/GET Get potential_3D property from the specified object and return the value.
% Inputs:
%   s         is a potential_3D object,
%   propName  is a potential_3D property. Property names are: n_evan, alpha_n, TF, TF_n and any
%             potential_2D property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, SET, DISPLAY, INIT_DATA, CALC_AMPLI_LIN, CALC_ETA_LIN
switch propName
    % First order quantities
    case {'n_transverse'}
        val = s.n_transverse;
    case {'N_1'}
        val = s.N_1;
    case {'mu_n'}
        val = s.mu_n;
    case {'I_n'}
        val = s.I_n;
    case 'k_0n'
        val = s.k_0n;
    case 'k_mn'
        val = s.k_mn;
    case 'TF_mn'
        val = s.TF_mn;
    case {'a_0n'}
        val = s.a_0n;
    case {'A_0n'}
        val = s.A_0n;
    % Second order quantities
    case {'n_transverse_free'}
        val = s.n_transverse_free;
    case {'n_vertical_free'}
        val = s.n_vertical_free;
    case {'N_2'}
        val = s.N_2;
    case 'beta_m'
        val = s.beta_m;
    case 'gamma_mn'
        val = s.gamma_mn;
    case 'a_0n_free'
        val = s.a_0n_free;
    % potential_2D properties
    case {'potential_2d', 'potential_2D'}
        val = s.potential_2D;
    otherwise
        val = get(s.potential_2D, propName);
end
