function TESTSerFour(varargin)
%TESTSERFOUR calcule les coef des series de fourier pour chaque
%signal de l'essai e à l'ordre Nf
%Il stocke tout ça dans le fichier .mat de l'essai

%TESTSerFour(test,Nf,iinter);
switch nargin
case 2 
    
    if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    if isa(varargin{2},'double')
        Nf = varargin{2};  %Initialisation of number of harmonics
    else
        error('2nd argument is not an integer');
    end
     tdebfin=[1];
    
       
case 3    
    
     if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    if isa(varargin{2},'double')
        Nf = varargin{2};  %Initialisation of number of harmonics
    else
        error('2nd argument is not an integer');
    end
    tdebfin=varargin{3};
    
otherwise
   error('Wrong number of input arguments')
end    

msg = sprintf('Calculating Fourier series ...    %s test n°%d ...',get(t,'name'),get(t,'num'));
disp(msg);

    fmeas = get(t,'fileMeas');
    fres = get(t,'fileRes');
    chan = get(t,'channelNames');
    unit = get(t,'channelUnits');
    paramNum = get(t,'paramNum');
    %Ttheo = paramNum(9);
    
    Ttheo=TESTGetParamNum(t,'Tp');
    [tdeb1 tfin1]=TESTGetInterval(t);
    
% initializing the signals for each channel
    data1 = load(get(varargin{1},'fileMeas'));
    dt=data1(2,1) - data1(1,1);
    nn=get(varargin{1},'channelNames');
    uu=get(varargin{1},'channelUnits');
    
    for ich = 1 : length(chan)    
%   s = signal(Y,dt,name,unit); 
    stab(ich) = signal(data1(:,ich+1),dt,nn{ich},uu{ich});
            
    end
        
        
   for iinter=1:1 %length(tdeb1);
       
%     tdeb = paramNum(5);
%     tfin = paramNum(6);
   
    tdeb=tdeb1(iinter);
    tfin=tfin1(iinter);
    
     for ich = 1 : length(chan)
       
        %s = signal(t,ich);
        s = SIGcut(stab(ich),tdeb,tfin,Ttheo);
        %SF1 = SIGSerFourLeastSquares(s,Nf,Ttheo);
        SF1 = SIGSerFour2(s,Nf,Ttheo);
        SFmod1(:,ich) = SF1(:,2);
        SFpha1(:,ich) = SF1(:,3);

     end
     
    SFfreq{iinter} = SF1(:,1);  
    SFmod{iinter}=SFmod1;
    SFpha{iinter}=SFpha1;
    tstart(iinter)=tdeb;
    tend(iinter)=tfin;
    
     if exist(fres) == 2
         save(fres,'tstart','tend','SFfreq','SFmod','SFpha','-append');
     else
         save(fres,'tstart','tend','SFfreq','SFmod','SFpha');
     end
    
   end
    
tex = sprintf('\b Done');
disp(tex);

end

