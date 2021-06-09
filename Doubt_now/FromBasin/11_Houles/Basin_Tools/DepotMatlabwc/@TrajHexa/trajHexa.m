function t = trajHexa(varargin)

%TrajHexa class constructor
%create an object of clas TrajHexa contenant
%- name
%- une matrice [pos] contenant les colonnes suivantes
%colonne 1 : X (mm)
%colonne 2 : Y (mm)
%colonne 3 : Z (mm)
%colonne 4 : Rx (deg)
%colonne 5 : Ry (deg)
%colonne 6 : Rz (deg)
%- dt (sec)
%
%
%
%Les formes du constructeur :
%t = trajHexa(name,[pos],dt)

switch nargin
case 0 
   t.pos = [];
   t.dt = 0;
   t.name = [];
     
   t = class(t,'trajHexa');
case 1
   if isa(varargin{1},'trajHexa')
        t = varargin{1};
   end
case 3
     if (isa(varargin{1},'char')&& ( isa(varargin{2},'double'))&& ( isa(varargin{3},'double')))   
        t.name = varargin{1};
        t.pos = varargin{2};
        t.dt = varargin{3};
        
        t = class(t,'trajHexa');
     end
     
     otherwise
   error('Wrong number of input arguments')
end

end
