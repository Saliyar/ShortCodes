function [tdeb1 tfin1]=TESTGetInterval(varargin)
%function TESTGetInterval(varargin)
%[teb1 tfin1]=TESTGetInterval(test)

switch nargin
case 1 
    
    if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    
    
    paramPPnames=get(t,'paramPostProNames');
    paramPPnum=get(t,'paramPostProNum');
    tdeb1=paramPPnum(find(ismember(paramPPnames,'Tstart')));
    tfin1=paramPPnum(find(ismember(paramPPnames,'Tend')));

    iinter=0;
    while ((iinter <= length(tdeb1)-1) && (tdeb1(iinter+1)<tfin1(iinter+1)) && ~isnan(tdeb1(iinter+1)) && ~isnan(tfin1(iinter+1))) 
      iinter=iinter+1;
    end
    if (iinter>0)
    tdeb1=tdeb1(1:iinter);
    tfin1=tfin1(1:iinter);
    
    else 
    tdeb1=[];
    tfin1=[];
    warning('tdeb and tfin are not correctly defined in excel file');
    end
   
   
end 

