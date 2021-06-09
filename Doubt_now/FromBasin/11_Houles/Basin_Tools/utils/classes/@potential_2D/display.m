function display(potential, name, tab)
% display(potential, name, tab)
% @POTENTIAL_2D/DISPLAY Command window display of a potential_2D object
% Inputs:
%   potential  is a potential_2D object,
%   name       is the name (optional) that will appear before the object data (usefull when wave is displayed from another object display).
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
disp([extra space 'n_evan      = ',num2str(potential.n_evan)])
display(potential.wave, [extra space 'wave data'], [extra space])
%
if potential.n_evan_free ~= 0
    disp([extra space 'n_evan_free = ',num2str(potential.n_evan)])
    display(potential.free, [extra space 'free data'], [extra space])
end
if nargin < 3
	disp(' ')
end

