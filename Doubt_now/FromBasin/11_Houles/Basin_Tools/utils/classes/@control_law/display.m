function display(c_law,name,tab)
% display(c_law,name,tab)
% @CONTROL_LAW/DISPLAY Command window display of a control_law object
% Inputs:
%   c_law  is a control_law object,
%   name   is the name (optional) that will appear before the object data (usefull when wave is displayed from another object display).
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
if c_law.active_paddles == 0
    disp([extra space 'active_paddles = ', '0 (= continuous)'])
else
    disp([extra space 'active_paddles = ', num2str(c_law.active_paddles)])
end
disp([extra space 'law            = ', c_law.law])
if strcmp(c_law.law,'dalrymple')
    disp([extra space 'X_d            = ',num2str(c_law.parameters(1))])
elseif strcmp(c_law.law,'restricted')
    disp([extra space 'X_d            = ',num2str(c_law.parameters(1))])
    disp([extra space 'y_d            = ',num2str(c_law.parameters(2))])
    disp([extra space 'y_f            = ',num2str(c_law.parameters(3))])
elseif strcmp(c_law.law,'disc')
    disp([extra space 'x_0            = ',num2str(c_law.parameters(1))])
    disp([extra space 'y_0            = ',num2str(c_law.parameters(2))])
    disp([extra space 'R              = ',num2str(c_law.parameters(3))])
end
if nargin < 3
	disp(' ')
end
