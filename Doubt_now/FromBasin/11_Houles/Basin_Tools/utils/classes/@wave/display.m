function display(wave,name,tab)
% display(wave,name,tab)
% @WAVE/DISPLAY Command window display of a wave object
% Inputs:
%   wave  is a wave object,
%   name  is the name (optional) that will appear before the object data (usefull when wave is displayed from another object display).
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
disp(' ')
if nargin == 1
    disp([inputname(1),' = '])
else
    disp([name,' = '])    
end
disp(' ')
space = '   ';
if nargin == 3
    extra = tab;
else
    extra = '';    
end
disp([extra space 'n_repeat     = ',num2str(wave.n_repeat)])
disp([extra space 'f_samp       = ',num2str(wave.f_samp)])
if strcmp(get(wave,'type'), 'biflap')
    if wave.TF_type == 0
        disp([extra space 'Transfer function not set up yet.'])
    else
        disp([extra space 'TF_type      = ',num2str(wave.TF_type)])
    end
end
display(wave.harmonic, [extra space 'harmonic data'],[extra space])
display(wave.wavemaker, [extra space 'wavemaker data'],[extra space])
if any(get(wave,'angle') ~= 0)
    display(wave.control_law, [extra space 'control law'],[extra space])
end
if nargin < 3
	disp(' ')
end
