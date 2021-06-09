function control = convert2nondim(control, depth)
% control = convert2nondim(control, depth)
% @CONTROL_LAW/CONVERT2NONDIM convert the control_law object to a nondimensional version
% with respect to depth and gravity acceleration
% Inputs:
%   control     is a control_law object in dimensional form
%   depth       is the depth in the dimensional object to be created
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%

% Already non dimensional ?
if control.dim == 0
    warning('convert2nondim:allready', 'Control_law object already in non dimensional form')
    return
end
% Length scale
x_scale = depth;
% Conversion
control = set(control, 'parameters', get(control,'parameters') / x_scale);
% 
control.dim = 0;
