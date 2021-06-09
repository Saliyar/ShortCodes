function display(harmonic, name, tab)
% display(harmonic,name,tab)
% @HARMONIC\DISPLAY Display method for timer objects.
%
%   DISPLAY(harmonic) displays the object harmonic in the command window.
%
%   DISPLAY(harmonic, name) shows the 'name' before displaying the object.
%
%   DISPLAY(harmonic, name, tab) use 'tab' spacing to tab the list of elements
%   in harmonic.

%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, get, plus, set, rotate, times, convert2nondim,
%    convert2dim, length, isempty, uminus, minus
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
disp([extra space 'dim      = ', int2str(harmonic.dim)])
disp([extra space 'n_harmo  = ', int2str(harmonic.n_harmo)])
disp([extra space 'harmo    = ', int2str(harmonic.harmo)])
disp([extra space 'ampli    = ', num2str(harmonic.ampli)])
disp([extra space 'phase    = ', num2str(harmonic.phase)])
disp([extra space 'angle    = ', num2str(harmonic.angle)])
if nargin < 3
	disp(' ')
end
