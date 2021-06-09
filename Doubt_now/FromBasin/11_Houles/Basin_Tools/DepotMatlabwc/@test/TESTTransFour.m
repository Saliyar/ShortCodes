function TESTTransFour(varargin)
%TESTTRANSFOUR calcule la fft pour un objet Test
%Il stocke tout ça dans le fichier .mat de l'essai
%
%Syntax
%TESTTransFour(test)
%TESTTransFour(test,offsetNull)
%TESTTransFour(test, iinter)
%TESTTransFour(test, 'withoffset'/'offsetNull', iinter)
%TESTTransFour(test, 'withoffset'/'offsetNull', iinter, pwelchParam)
%%TESTTransFour(test, 'withoffset'/'offsetNull', iinter, pwelchParam,[freqmin freqmax])
%test : object of class test
%offsetNull : double if == 1 then the signals mean value is substracted

switch nargin
case 1  
   if (isa(varargin{1},'test'))
       t = varargin{1};
       offsetNull = 0;
       tdebfin=[1];
        paramPwelch={[],[],[]};
   else
       error('Wrong type of input arguments')
   end
case 2  
   if (isa(varargin{1},'test') && isa(varargin{2},'double'))
       t = varargin{1};
       offsetNull = 0;
       tdebfin=varargin{2};  
   elseif (isa(varargin{1},'test') && ischar(varargin{2}))
       if (strcmp(varargin{2},'offsetNull'))
           t = varargin{1};
           offsetNull=1;
           tdebfin=[1];
       elseif (strcmp(varargin{2},'withoffset'))
           t = varargin{1};
           offsetNull=0;
           tdebfin=[1];
       else
           error('Wrong ''offset'' keyword argument')
       end
   else
       error('Wrong type of input arguments')
   end
    paramPwelch={[],[],[]};
   
case 3    
    
     if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
     end
    
    if ischar(varargin{2})
       if (strcmp(varargin{2},'offsetNull'))
           offsetNull=1;
           tdebfin=[1];
       elseif (strcmp(varargin{2},'withoffset'))
           offsetNull=0;
           tdebfin=[1];
       else
           error('Wrong ''offset'' keyword argument')
       end
         %Initialisation of number of harmonics
    else
        error('2nd argument is not a string');
    end
     if (isa(varargin{3},'double') )
       tdebfin=varargin{3};   
         %Initialisation of number of harmonics
    else
        error('3rd argument is not of type ''double'' ');
     end
     paramPwelch={[],[],[]};

case 4    
    
    if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
    end
    
    if ischar(varargin{2})
        if (strcmp(varargin{2},'offsetNull'))
            offsetNull=1;
            tdebfin=[1];
        elseif (strcmp(varargin{2},'withoffset'))
            offsetNull=0;
            tdebfin=[1];
        else
            error('Wrong ''offset'' keyword argument')
        end
        %Initialisation of number of harmonics
    else
        error('2nd argument is not a string');
    end
    
    if (isa(varargin{3},'double') )
        tdebfin=varargin{3};
        %Initialisation of number of harmonics
    else
        error('3rd argument is not of type ''double'' ');
    end
    
    if (isa(varargin{4},'cell') )
        paramPwelch=varargin{4};
        %Initialisation of number of harmonics
    else
        error('3th argument is not of type ''cell'' ');
    end
otherwise
        error('Wrong number of input arguments')
end


msg = sprintf('Calculating Fourier transform ... %s test n°%d ...',get(t,'name'),get(t,'num'));
disp(msg);

fmeas = get(t,'fileMeas');
fres = get(t,'fileRes');
chan = get(t,'channelNames');
unit = get(t,'channelUnits');
paramNum = get(t,'paramNum');
typ = TESTGetParamNum(t,'Type');


 Ttheo=TESTGetParamNum(t,'Tp');
 [tdeb1 tfin1]=TESTGetInterval(t);
%tdeb = paramNum(5);
%tfin = paramNum(6);
%Ttheo = paramNum(9);

% initializing the signals for each channel
    data1 = load(get(varargin{1},'fileMeas'));
    dt=data1(2,1) - data1(1,1);
    nn=get(varargin{1},'channelNames');
    uu=get(varargin{1},'channelUnits');
    
    for ich = 1 : length(chan)    
%   s = signal(Y,dt,name,unit); 
    stab(ich) = signal(data1(:,ich+1),dt,nn{ich},uu{ich});
            
    end
        
        
   for iinter=tdebfin;
    
    %disp('intesttransfour')
    tdeb=tdeb1(iinter);
    tfin=tfin1(iinter);

    clear TFmod1;
    clear TFpha1;
    clear TFdsp1;
    clear Pwelchdsp1;
    clear Pwelchfreq1;

    for ich = 1:length(chan)
 %   s = signal(t,ich);
 
    if (typ == 1)   %Regular Wave case
        sCut = SIGcut(stab(ich),tdeb,tfin,Ttheo);
    else                %irregular or decay tests cases
        sCut = SIGcut(stab(ich),tdeb,tfin);
    end
    TF1 = SIGTransFour(sCut,offsetNull);
    
    TFmod1(:,ich) = TF1(:,2);
    TFpha1(:,ich) = TF1(:,3);
    TFdsp1(:,ich) = TF1(:,4);
   
   % if (paramNum(4) == 2 | paramNum(4) == 4 )
    Pwel1=SIGPwelch(sCut,offsetNull,paramPwelch);
   
    
    Pwelchdsp1(:,ich)=Pwel1(:,2);
    Pwelchfreq1=Pwel1(:,1);
   % end
    
    end
%     iinter
%     tdeb
%     tfin
%    
    
     if exist(fres) == 2
        load(fres); 
     end
    
    
    TFfreq{iinter} = TF1(:,1);
    TFmod{iinter}=TFmod1;
    TFpha{iinter}=TFpha1;
    TFdsp{iinter}=TFdsp1;
    
    %if (paramNum(4) == 2 | paramNum(4) == 4 )
    Pwelchfreq{iinter}=Pwelchfreq1;
    Pwelchdsp{iinter}=Pwelchdsp1;
    Pwelchparam{iinter}=paramPwelch;
    %end
    
    tstart(iinter)=tdeb;
    tend(iinter)=tfin;
    
    if exist(fres) == 2
    save(fres,'tstart','tend','TFfreq','TFmod','TFpha','TFdsp', 'Pwelchfreq','Pwelchdsp','Pwelchparam','-append');
    else
    save(fres,'tstart','tend','TFfreq','TFmod','TFpha','TFdsp', 'Pwelchfreq','Pwelchdsp','Pwelchparam');
    end
    
   end
tex = sprintf('\b Done');
disp(tex);
end


