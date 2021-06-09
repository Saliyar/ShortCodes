function control = convert2dim(control, depth)
% control = convert2dim(control, depth)
% @CONTROL_LAW/CONVERT2DIM convert the control_law object to an dimensional version
% with respect to depth and gravity acceleration
% Inputs:
%   control     is a control_law object in nondimensional form (depth=1 and gravity=1)
%   depth       is the new depth in the dimensional object to be created
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
if control.dim == 1
    warning('convert2dim:allready', 'Control_law object already in dimensional form')
    return
end
% Length scale
if nargin > 1
    x_scale = depth;
else
    error('control_law:convert2dim:missingdepth', 'Depth is missing')
end
% Conversion
control = set(control, 'parameters', get(control,'parameters') * x_scale);
% 
control.dim = 1;
