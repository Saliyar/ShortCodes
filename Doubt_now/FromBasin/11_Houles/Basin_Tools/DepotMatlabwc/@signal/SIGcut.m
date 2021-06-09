function val = SIGcut(varargin)
%function of class signal
%Cuts the signal between the time teb and tfin 
%specified in seconds and returns the new signal
%in object val.
%If the Ttheo is specified, then the returned signal
%length is a multiple of Ttheo
%
%syntax : 
%val = SIGcut(signal,tdeb,tfin)
%val = SIGcut(signal,tdeb,tfin,Ttheo)
%signal is an object of class signal
%val is an object of class signal
%tdeb and tfin are double objects

%check input arguments
switch nargin
case 3  
   if (isa(varargin{1},'signal') && isa(varargin{2},'double') && isa(varargin{3},'double'))
       s = varargin{1};
       tdeb=varargin{2};
       tfin=varargin{3};      
   else
       error('Wrong type of input arguments')
   end
case 4
    if (isa(varargin{1},'signal') && isa(varargin{2},'double') && isa(varargin{3},'double') && isa(varargin{4},'double'))
       s = varargin{1};
       tdeb=varargin{2};
       tfin=varargin{3};
       Ttheo = varargin{4}; 
       NT=floor((tfin-tdeb)/Ttheo);
       tfin = tdeb + NT*Ttheo;
    else
       error('Wrong type of input arguments')
    end
    
otherwise
   error('Wrong number of input arguments')
end    

ideb = round(tdeb/s.dt)+1;
ifin = round(tfin/s.dt);

dataCut = s.Y([ideb:ifin]);

val = signal(dataCut,s.dt,s.nom,s.unite);

end

