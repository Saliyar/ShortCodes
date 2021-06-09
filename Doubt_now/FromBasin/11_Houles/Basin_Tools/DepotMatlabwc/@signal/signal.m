function s = signal(varargin)
%SIGNAL signal class constructor, 
%create an object of signal class which properties are :
%- Y the vector containing the signal
%- dt the sampling period
%- nom : the signal name
%- unite : the signal unit 
%
%Syntax :
%s = signal(Y,dt,name,unit) 
%s = signal(file,numcol,name,unit)
%s=signal(test,channelnumber)
%s=signal(test,channelname)


switch nargin
case 0 
   s.Y = [];
   s.dt = 0;
   s.nom = [];
   s.unite = [];
   
   s = class(s,'signal');
case 1
   if isa(varargin{1},'signal')
        s = varargin{1};
   end
     
case 2
     if (isa(varargin{1},'test')&& ( isnumeric(varargin{2})))      
       data1 = load(get(varargin{1},'fileMeas'));
       
%    
       s.Y = data1(:,varargin{2}+1);
       s.dt = data1(2,1) - data1(1,1);
       nn=get(varargin{1},'channelNames');
       s.nom =  nn{varargin{2}};
       uu=get(varargin{1},'channelUnits');
       %uu(varargin{2})
       s.unite =  uu{varargin{2}};
     end
     if (isa(varargin{1},'test') && ( ischar(varargin{2})))
      nn=get(varargin{1},'channelNames');
        ind=find(ismember(nn,varargin{2}));
        if (size(ind,1) <1)
            error('Channel name not found in ''channelNames'' ')
        end
        if (size(ind,1) >1)
            error('several channels have this name in ''channelNames'' ')
        end
        data1 = load(get(varargin{1},'fileMeas'));
        ind
       whos
%        s.Y = data1.data(:,ind+1);
%        s.dt = data1.data(2,1) - data1.data(1,1);
        s.Y = data1(:,ind+1);
         s.dt = data1(2,1) - data1(1,1);
        nn=get(varargin{1},'channelNames');
       s.nom =  nn{ind};
       uu=get(varargin{1},'channelUnits');
       %uu(varargin{2})
       s.unite =  uu{ind};
     end
        
     
     s = class(s,'signal');
case 4     
    if isa(varargin{1},'double')
       s.Y = varargin{1};
       %s.Y is forced to be a column vector
       sizeY = size(s.Y );
       if sizeY(1) == 1; s.Y = s.Y';end       
       s.dt = varargin{2};
       s.nom =  varargin{3};
       s.unite =  varargin{4};
    end
    
     if isa(varargin{1},'char')
       nomfich = varargin{1};
       data = importdata(nomfich);
       s.Y = data(:,varargin{2}+1);
       s.dt = data(2,1) - data(1,1);
       s.nom =  varargin{3};
       s.unite =  varargin{4};
    end
   
   
   
   s = class(s,'signal');
otherwise
   error('Wrong number of input arguments')
end

end

