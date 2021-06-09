function wmk = convert2nondim(wmk)
% wmk = convert2nondim(wmk)
% WAVEMAKER/CONVERT2NONDIM convert the wavemaker object to a nondimensional
% version with respect to depth and gravity acceleration (so that depth=1 and gravity=1 after conversion).
% Input:
%   wmk is a wavemaker object in dimensional form
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%

% Already non dimensional ?
if wmk.dim == 0
    warning('convert2nondim:allready', 'Wavemaker object already in non dimensional form')
    return
end
% Compatibility checking
% if wmk.depth == 1
%    warning('convert2nondim:depthone','Trying to convert a wavemaker object with depth=1 into non dimensional form,') 
%    warning('Please make sure that the wavemaker object has been built in dimensional form,') 
%    warning('or make sure that the ramp duration has been accordingly defined.') 
% end
depth   = get(wmk,'depth');
gravity = 9.81;
% Length and time scales
x_scale = depth;
t_scale = sqrt(x_scale / gravity);
% Conversion
% wmk = set(wmk,'depth',       get(wmk,'depth')        / x_scale);
wmk = set(wmk,'hinge_bottom',get(wmk,'hinge_bottom') / x_scale);
wmk = set(wmk,'middle_flap', get(wmk,'middle_flap')  / x_scale);
wmk = set(wmk,'ramp',        get(wmk,'ramp')         / t_scale);
wmk = set(wmk,'Ly',          get(wmk,'Ly')           / x_scale);
% 
wmk.dim = 0;
