function c_law = control_law(active_paddles, law, parameters, dim) 
%c_law = control_law(active_paddles, type, parameters, dim)
%@CONTROL_LAW\CONTROL_LAW control_law class constructor.
%   active_paddles           describes the active flaps (vector of integer
%   representing the number of the working paddles)
%   law                      wavemaker control law (among 'snake',
%   'dalrymple', 'disc'...)
%   parameters               depending on the law (always in dimensional form)
%   dim                      dimensional form (1) or nondimensional (0)
%   (see also the pdf file classes.pdf on the objects designed in MatLab)
%
%   See also get, set, display, convert2dim, convert2nondim
%
switch nargin
    case 0 % default object
        c_law.dim            = 1;
        c_law.active_paddles = 0;
        c_law.law            = 'snake';
        c_law.parameters     = [];
        c_law                = class(c_law,'control_law');
    case 1
        if isa(active_paddles, 'control_law')
            c_law = active_paddles;
        else
            error('Wrong type/number of input argument')
        end
    case {2,3,4}
        c_law.dim            = 1;
        c_law.active_paddles = active_paddles;
        if nargin == 4 
            if not(dim==1 || dim==0)
                error('Fourth argument (dim) must be 0 or 1')
            else
                c_law.dim = dim;
            end
        end
        if strcmp(law,'snake')
            c_law.law        = 'snake';
            c_law.parameters = [];
        elseif strcmp(law,'dalrymple') || strcmp(law,'Dalrymple')
            c_law.law        = 'dalrymple';
            c_law.parameters = parameters(1);
        elseif strcmp(law,'disc')
            c_law.law        = 'disc';
            c_law.parameters = parameters(1:3);
        elseif strcmp(law,'restricted')
            c_law.law        = 'restricted';
            c_law.parameters = parameters(1:3);
        else
            error('Unknown control law')
        end
%         if (strcmp() || strcmp()) && dim==1
        c_law = class(c_law,'control_law');
    otherwise
        error('Wrong number of input arguments')
end