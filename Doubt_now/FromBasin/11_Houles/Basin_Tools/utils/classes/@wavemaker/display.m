function display(wmk,name,tab)
% display(wmk)
% @WAVEMAKER/DISPLAY Command window display of a wavemaker object
%
disp(' ')
if nargin == 1
    disp([inputname(1),' = '])
else
    disp([name,' = '])    
end
space = '   ';
if nargin == 3
    extra = tab;
else
    extra = '';    
end
disp(' ')
disp([extra space 'dim          = ', int2str(wmk.dim)])
disp([extra space 'depth        = ', num2str(wmk.depth)])
disp([extra space 'type         = ', num2str(wmk.type)])
disp([extra space 'hinge_bottom = ', num2str(wmk.hinge_bottom)])
disp([extra space 'middle_flap  = ', num2str(wmk.middle_flap)])
disp([extra space 'n_paddles    = ', num2str(wmk.n_paddles)])
disp([extra space 'Ly           = ', num2str(wmk.Ly)])
disp([extra space 'type_ramp    = ', num2str(wmk.type_ramp)])
disp([extra space 'ramp         = ', num2str(wmk.ramp)])
if nargin < 3
	disp(' ')
end
