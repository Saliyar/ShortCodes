function wmk = convert2dim(wmk, depth)
% wmk = convert2dim(wmk, depth)
% WAVEMAKER/CONVERT2DIM convert the wavemaker object to an dimensional version
% with respect to depth and gravity acceleration
% Inputs:
%   wmk is a wavemaker object in nondimensional form (depth=1 and gravity=1)
%   depth is the new depth in the dimensional object to be created
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if wmk.dim == 1
    warning('convert2dim:allready', 'Wavemaker object already in dimensional form')
    return
end
gravity = 9.81;
% Length and time scales
if nargin > 1
    if depth ~= get(wmk,'depth')
        warning('convert2dim:depth', 'Trying to put a dimesional form with a different depth')
    end
    x_scale = depth;
else
    x_scale = get(wmk,'depth');
end
t_scale = sqrt(x_scale / gravity);
% Conversion
wmk = set(wmk,'depth',       x_scale);
wmk = set(wmk,'hinge_bottom',get(wmk,'hinge_bottom') * x_scale);
wmk = set(wmk,'middle_flap', get(wmk,'middle_flap')  * x_scale);
wmk = set(wmk,'ramp',        get(wmk,'ramp')         * t_scale);
wmk = set(wmk,'Ly',          get(wmk,'Ly')           * x_scale);
% 
wmk.dim = 1;
