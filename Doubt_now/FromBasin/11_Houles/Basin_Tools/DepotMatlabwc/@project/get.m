function val = get(a, propName)
% GET Get asset properties from the specified object
% and return the value
switch propName
case 'name'
   val = a.name;
case 'path'
   val = a.path;
case 'pathMeas'
   val = a.pathMeas;
case 'pathRes'
   val = a.pathRes;
case 'pathFig'
   val = a.pathFig;
case 'fileList'
   val = a.fileList;
   
    
otherwise
   error([propName,' Is not a valid property'])
end