function val = eval_data(wave, property)
% val = eval_data(wave, property)
% @WAVE\EVAL_DATA evaluates complementary data of the wave object
% Inputs:
%   wave      is a wave object,
%   property  is the one to be displayed or returned, among T_repeat, pulsation, frequency, period, wavenumber, wavelength
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
switch property
    case {'T_repeat'}
        val = wave.n_repeat / wave.f_samp;
    case {'pulsation', 'omega', 'Pulsation'}
        f_base = 1 ./ eval_data(wave, 'T_repeat');
        val    = 2 * pi * get(wave,'harmo') * f_base;
    case {'frequency', 'f', 'freq', 'Frequency'}
        f_base = 1 ./ eval_data(wave, 'T_repeat');
        val    = get(wave,'harmo') * f_base;
    case {'period','T', 'Period'}
        f_base = 1 ./ eval_data(wave, 'T_repeat');
        val    = 1./ (get(wave,'harmo') * f_base);
    case {'wavenumber', 'k', 'Wavenumber'}
        f_base = 1 ./ eval_data(wave, 'T_repeat');
        freq   = get(wave,'harmo') * f_base;
        if get(wave.harmonic, 'dim') == 1
            val    = wave_number(freq, get(wave,'depth'));
        else
            val    = wave_number(freq);
        end
    case {'wavelength', 'Wavelength'}
        f_base = 1 ./ eval_data(wave, 'T_repeat');
        freq   = get(wave,'harmo') * f_base;
        if get(wave.harmonic, 'dim') == 1
            val    = 2 * pi ./ wave_number(freq, get(wave,'depth'));
        else
            val    = 2 * pi ./ wave_number(freq);
        end
    otherwise
        error('Unknown wave property in eval_data. Available properties are: T_repeat, pulsation, frequency, period, wavenumber, wavelength')
end
