function val = get(s,propName)
% val = get(s,propName)
% @WAVE/GET Get wave property from the specified object and return the value.
% Inputs:
%   s         is a wave object,
%   propName  is a wave property. Property names are: TF_type, f_samp, n_repeat, harmo, amplitude, phase, angle and any
%             wave, wavemaker and control_law property.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
switch propName
    case {'TF_type','TF'}
        val = s.TF_type;
    case {'f_samp','f_acq'}
        val = s.f_samp;
    case 'n_repeat'
        val = s.n_repeat;
    case {'harmonic', 'wave', 'data'}
        val = s.harmonic;
    case {'harmo','amplitude','Amplitude','ampli','phase','Phase','angle','direction','Direction','n_harmo'}
        val = get(s.harmonic, propName);
    case {'Height'}
        val = 2 * get(s.harmonic, 'amplitude');
    case {'T_repeat','frequency','Frequency','f','period','Period','T','pulsation','omega',...
            'wavenumber','k','wavelength','freq'}
        val = eval_data(s, propName);
    case {'wavemaker', 'wmk'}
        val = s.wavemaker;
    case {'dim', 'depth', 'type', 'hinge_bottom', 'middle_flap', 'n_paddles', ...
            'Ly', 'L_y', 'type_ramp', 'ramp'}
        val = get(s.wavemaker, propName);
    case {'control_law'}
        val = s.control_law;
    case {'active_paddles','law','parameters'}
        val = get(s.control_law, propName);
    otherwise
        error([propName ,' is not a valid wave property'])
end
