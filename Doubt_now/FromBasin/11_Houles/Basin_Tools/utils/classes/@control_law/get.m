function val = get(s,propName)
% val = get(s,propName)
% @CONTROL_LAW/GET Get control_law property from the specified object and return the value.
% Inputs:
%   s         is a control_law object,
%   propName  is a control_law property. Property names are:
%   active_paddles, law and parameters
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
switch propName
    case {'active_paddles'}
        val = s.active_paddles;
    case {'law', 'type'}
        val = s.law;
    case {'dim'}
        val = s.dim;
    case {'parameters'}
        val = s.parameters;
    otherwise
        error('Wrong Property name')
end
