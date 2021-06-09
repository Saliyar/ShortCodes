function display(potential, name, tab)
% display(potential,name,tab)
% @POTENTIAL_3D/DISPLAY Command window display of a potential_3D object
% Inputs:
%   potential  is a potential_3D object,
%   name       is the name (optional) that will appear before the object data (usefull when wave is displayed from another object display).
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
% See also POTENTIAL_3D, GET, SET, INIT_DATA, CALC_AMPLI_LIN, CALC_ETA_LIN
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
disp([extra space 'n_transverse      = ',num2str(potential.n_transverse)])
disp([extra space 'N_1               = ',num2str(potential.N_1)])
disp([extra space 'N_2               = ',num2str(potential.N_2)])
disp([extra space 'n_transverse_free = ',num2str(potential.n_transverse_free)])
disp([extra space 'n_vertical_free   = ',num2str(potential.n_vertical_free)])
display(potential.potential_2D, [extra space 'potential_2D data'], [extra space])
if nargin < 3
	disp(' ')
end
