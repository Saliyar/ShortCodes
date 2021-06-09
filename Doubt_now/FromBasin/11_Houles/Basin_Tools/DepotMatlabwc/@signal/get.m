function val = get(a, propName)
% GET Get asset properties from the specified object
% and return the value

switch propName
case 'nom'
   val = a.nom;
case 'unite'
   val = a.unite;
case 'dt'
   val = a.dt;
case 'Y'
   val = a.Y;

    
otherwise
   error([propName,' Is not a valid property'])
end