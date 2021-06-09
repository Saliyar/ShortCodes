function val = TESTGetParamNum(varargin)
%TESTGetParamNum(test,'parametername')

switch nargin
case 2 
    
    if (isa(varargin{1},'test') && isa(varargin{2},'char'))
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    
    
    paramNum = get(t,'paramNum');
    paramNames = get(t,'paramNames');
   % whos
    val=paramNum(find(ismember(paramNames,varargin{2})));
    
    if (length(val)< 1 | (length(val)>1))
        error(['parameter ''' varargin{2} ''' multiply or not defined']);
    end
end

