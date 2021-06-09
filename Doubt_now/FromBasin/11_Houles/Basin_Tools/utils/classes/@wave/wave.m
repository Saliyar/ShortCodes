function wave_var = wave(T_repeat, f_samp, harmo, wmk, c_law)
% wave_var = wave(T_repeat, f_samp, harmo, wmk, c_law)
% @WAVE\WAVE class constructor.
%   A wave object contains the variables describing a wave in a wave tank
% Inputs:
%   T_repeat  is the repeat period in s.
%   f_samp    is the sampling frequency of the signal that controls the wavemaker
%   harmo     is a harmonic object
%   wmk       is a wavemaker object
%   c_law     is the control law for oblique waves
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
switch nargin
    case {0}
        wave_var.n_repeat  = 1;
        wave_var.f_samp    = 1;
        wave_var.TF_type   = 0;
        wave_var           = class(wave_var,'wave',wavemaker(),harmonic(), control_law());
    case {1}
        if isa(T_repeat,'wave')
            wave_var = T_repeat;
        else
            error('Wrong argument type')
        end
    case {4,5}
        if nargin < 5 %&& any(get(harmo,'angle') ~= 0)
            c_law = control_law(0, 'snake');
        end
        wave_var.n_repeat  = floor(T_repeat*f_samp+0.1); % adjusted so that it's the good number of points
        wave_var.f_samp    = f_samp;
        switch get(wmk,'type')
            case {'piston'}
                wave_var.TF_type = 'piston';
            otherwise
                wave_var.TF_type   = 0;
        end
        if get(harmo,'dim') ~= get(wmk,'dim')
            error('Dimension mismatch between input wave object and input wavemaker object')
        end
        switch get(wmk,'dim')
            case {1}
                if get(c_law,'dim') == 0
                    c_law = convert2dim(c_law, get(wmk,'depth'));
                end
            case {0}
                if get(c_law,'dim') == 1
                    c_law = convert2nondim(c_law, get(wmk,'depth'));
                end
        end
        wave_var = class(wave_var,'wave', wavemaker(wmk), harmonic(harmo), control_law(c_law));
    otherwise
        error('wave:input', 'Wrong number of input arguments')
end
