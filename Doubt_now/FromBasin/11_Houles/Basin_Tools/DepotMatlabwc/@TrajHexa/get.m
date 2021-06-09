function val = get(a, propName)
% GET get properties of the specified object and return 
% in val

switch propName
case 'name'
   val = a.name;
case 'pos'
   val = a.pos;
case 'dt'
   val = a.dt;
    
otherwise
   error([propName,' Is not a valid property'])
end