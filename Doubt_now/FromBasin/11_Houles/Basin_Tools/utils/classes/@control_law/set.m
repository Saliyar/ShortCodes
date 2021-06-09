function s = set(s,varargin)
% s = set(s,varargin)
% @CONTROL_LAW/SET set control_law property to the specified value.
% Inputs:
%   s         is a control_law object,
%   varargin  is a set of control_law property name and value. Property
%   names are: active_paddles, law and parameters
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
property_argin = varargin;
while length(property_argin) >= 2,
    prop = property_argin{1};
    val = property_argin{2};
    property_argin = property_argin(3:end);
    switch prop
        case {'active_paddles'}
            s.active_paddles  = val;
        case {'law', 'type'}
            s.law  = val;
        case {'parameters'}
            s.parameters  = val;
        otherwise
            error([prop ,' is not a valid control_law property. Control_law properties: active_paddles, law and parameters'])
    end
end