function val = get(s,propName)
% val = get(s,propName)
% @POTENTIAL_2D/GET Get potential_2D property from the specified object and return the value.
% Inputs:
%   s         is a potential_2D object,
%   propName  is a potential_2D property. Property names are: n_evan, alpha_n, TF, TF_n and any
%             wave_2D property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
switch propName
    case {'n_evan', 'evanescent'}
        val = s.n_evan;
    case {'n_evan_free'}
        val = s.n_evan_free;
    case {'alpha_n'}
        val = s.alpha_n;
    case {'sigma_n'}
        val = s.sigma_n;
    case 'TF'
        val = s.TF;
    case {'TF_n'}
        val = s.TF_n;
    case {'free'}
        val = s.free;
    case {'wave'}
        val = s.wave;
    otherwise
        val = get(s.wave, propName);
end
