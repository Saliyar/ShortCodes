function wave = convert2dim(wave, depth)
% wave = convert2dim(wave)
% @WAVE/CONVERT2DIM convert the wave object to a dimensional version
% with respect to depth and gravity acceleration
% Inputs:
%   wave   is a wave object in nondimensional form (depth=1 and gravity=1)
%   depth  is the new depth in the dimensional object to be created
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if get(wave,'dim') == 1
    warning('convert2dim:allready', 'wave object already in dimensional form')
    return
end
gravity = 9.81;
if nargin == 1
    depth = get(wave, 'depth');
end
% Time scale (length scale is depth)
t_scale = sqrt(depth / gravity);
% Conversion
if nargin > 1
    wave = set(wave, 'wavemaker', convert2dim(get(wave, 'wavemaker'), depth));
else
    wave = set(wave, 'wavemaker', convert2dim(get(wave, 'wavemaker')));
end
wave = set(wave, 'wave',        convert2dim(get(wave, 'wave'), depth));
wave = set(wave, 'control_law', convert2dim(get(wave, 'control_law'), depth));
wave = set(wave, 'f_samp',      get(wave, 'f_samp') / t_scale);
