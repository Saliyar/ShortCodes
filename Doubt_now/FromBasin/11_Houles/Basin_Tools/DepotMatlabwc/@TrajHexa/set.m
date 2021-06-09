function set(a, propName,val)
% SET set properties of the specified object

switch propName
case 'name'
   a.name = val;
case 'pos'
   a.pos = val;
case 'dt'
   a.dt = val;
    
otherwise
   error([propName,' Is not a valid property'])
end