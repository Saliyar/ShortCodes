function val = get(a, propName)
% GET Get asset properties from the specified object
% and return the value
switch propName
%The fields of class test
case 'num'
   val = a.num;
case 'fileMeas'
   val = a.fileMeas;
case 'fileRes'
   val = a.fileRes;
case 'channelNames'
   val = a.channelNames;
case 'channelUnits'
   val = a.channelUnits;
case 'channelGroups'         
   val = a.channelGroups;    
case 'channelGroupsFreq'        
   val = a.channelGroupsFreq;    
case 'paramNames'
   val = a.paramNames;
case 'paramNum'
   val = a.paramNum;
case 'paramStr'
   val = a.paramStr;
case 'paramPostProNames'
   val=a.paramPostProNames;
case 'paramPostProNum'   
   val=a.paramPostProNum;
                
%The fields inherited from class project
case 'name'
   val = get(a.project,'name');
   case 'path'
   val = get(a.project,'path');
case 'pathMeas'
   val = get(a.project,'pathMeas');
case 'pathRes'
   val = get(a.project,'pathRes');
case 'pathFig'
   val = get(a.project,'pathFig');
case 'fileList'
   val = get(a.project,'fileList');
   
    
otherwise
   error([propName,' Is not a valid property'])
end