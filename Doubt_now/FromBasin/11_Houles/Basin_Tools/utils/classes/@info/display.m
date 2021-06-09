function display(info,name,tab)
% display(info,name,tab)
% @INFO/DISPLAY Command window display of a wave info object
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
disp([extra space 'type       = ',num2str([info.input])])
disp([extra space 'dim        = ',num2str([info.dim])])
if sum([info.dim]) == 1
    disp([extra space 'depth      = ',num2str([info.depth]),' m'])
    disp([extra space 'pulsation  = ',num2str([info.omega]),' Rad/s'])
    disp([extra space 'frequency  = ',num2str([info.freq]),' Hz'])
    disp([extra space 'period     = ',num2str([info.period]),' s'])
    disp([extra space 'wavelength = ',num2str([info.lambda]),' m'])
    disp([extra space 'wavenumber = ',num2str([info.k]),' m^-1'])
elseif prod([info.dim]) == 0
    disp([extra space 'pulsation  = ',num2str([info.omega])])
    disp([extra space 'frequency  = ',num2str([info.freq])])
    disp([extra space 'period     = ',num2str([info.period])])
    disp([extra space 'wavelength = ',num2str([info.lambda])])
    disp([extra space 'wavenumber = ',num2str([info.k])])
else
    disp([extra space 'parameters are not displayed because dim is mixed up'])
end
if nargin < 3
	disp(' ')
end

