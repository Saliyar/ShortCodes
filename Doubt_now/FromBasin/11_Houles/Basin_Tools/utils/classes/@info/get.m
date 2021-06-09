function val = get(s,propName)
% val = get(s,propName)
% @INFO/GET Get wave property from the specified info object
% and return the value. Property names are: frequency, depth, dim
% period, pulsation, wavelength, wavenumber
switch propName
    case 'dim'
        val = [s.dim];
    case 'depth'
        val = [s.depth];
    case {'pulsation', 'puls'}
        val = [s.omega];
    case {'period', 'per'}
        val = [s.period];
    case {'frequency', 'freq'}
        val = [s.freq];
    case {'wavenumber', 'wave_number'}
        val = [s.k];
    case {'wavelength', 'wave_length', 'lambda'}
        val = [s.lambda];
    otherwise
        error([propName ,' is not a valid info property']) % should stop the function
end
