function wave = convert2nondim(wave)
% wave = convert2nondim(wave)
% @WAVE/CONVERT2NONDIM convert the wave object to a nondimensional
% version with respect to depth and gravity acceleration (so that depth=1 and gravity=1 after conversion).
% Input:
%   wave  is a wave object in dimensional form
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if get(wave,'dim') == 0
    warning('convert2nondim:allready', 'wave object already in non dimensional form')
    return
end
x_scale = get(wave, 'depth');
gravity = 9.81;
% Time scale (length scale is depth
t_scale = sqrt(x_scale / gravity);
% Conversion
wave = set(wave, 'wavemaker',   convert2nondim(get(wave, 'wavemaker')));
wave = set(wave, 'wave',        convert2nondim(get(wave, 'wave'), x_scale));
wave = set(wave, 'control_law', convert2nondim(get(wave, 'control_law'), x_scale));
wave = set(wave, 'f_samp',      get(wave, 'f_samp') * t_scale);
