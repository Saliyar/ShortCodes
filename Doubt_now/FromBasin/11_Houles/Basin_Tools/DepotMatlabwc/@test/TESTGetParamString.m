function val = TESTGetParamString(varargin)


%TESTGetParamString(test,'parametername')

switch nargin
case 2 
    
    if (isa(varargin{1},'test') && isa(varargin{2},'char'))
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    
    
    paramStr = get(t,'paramStr');
    paramNames = get(t,'paramNames');
    val=paramStr{find(ismember(paramNames,varargin{2}))};
    
    if (length(val)< 1 )
        error(['parameter ''' varargin{2} ''' not defined']);
    end
end

