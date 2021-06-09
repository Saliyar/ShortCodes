function TESTTransFunc(varargin)
%TESTTransFunc calcule les fonctions de transferts pour un objet Test
%Toutes les voies par rapport à la voie définie comme ref
%Il stocke les résultats dans le fichier .mat de l'essai
%
%Syntax
%TESTTransFunc(test, signal)
%TESTTransFunc(test, numcol)
%TESTTransFunc(test, signal,'withoffset'/'offsetNull')
%TESTTransFunc(test, numcol,'withoffset'/'offsetNull')
%TESTTransFunc(test, signal,'withoffset'/'offsetNull',iinter)
%TESTTransFunc(test, numcol,'withoffset'/'offsetNull',iinter)
%

%TESTTransFour(test, signal/numsignal, offsetNull)
%TESTTransFour(test, signal/numsignal, iinter)
%TESTTransFour(test, signal/numsignal, 'withoffset'/'offsetNull', iinter)
%TESTTransFour(test, signal/numsignal, 'withoffset'/'offsetNull', iinter, pwelchParam)
%TESTTransFour(test, signal/numsignal, 'withoffset'/'offsetNull', iinter, pwelchParam)
%test : object of class test
%offsetNull : double if == 1 then the signals mean value is substracted
%signal : entry signal which is used for the Transfer function estimation
%
%
%Outputs : 
% 'tstart'
% 'tend'
% 'TFuncfreq'
% 'TFuncmod'
% 'TFuncpha'
% 'TCoherfreq'
% 'TCohermod'
% 'Pwelchparam'
% 'SigRefName'
%


%Input arguments check up-------------------------------------------------
%-------------------------------------------------------------------------

switch nargin
case 2
   %2 arguments d'entrées : objet test et objet signal
   if (isa(varargin{1},'test') && isa(varargin{2},'signal'))
       t = varargin{1};
       s1=varargin{2};
       offsetNull = 0;
       tdebfin=[1];
       paramPwelch={[],[],[]};
   %2 arguments d'entrées : objet test et un double
   elseif (isa(varargin{1},'test') && isa(varargin{2},'double'))
       t = varargin{1};
       s1=signal(t,varargin{2});
       offsetNull = 0;
       tdebfin=[1];
       paramPwelch={[],[],[]};
   else       
       error('Wrong type of input arguments')
   end
case 3
   %3 arguments d'entrée : objet test, objet signal, 
   if isa(varargin{1},'test')
       t = varargin{1};
   else
       error('1st argument is not a test')
   end  
   if (isa(varargin{2},'signal'))
       s1=varargin{2};
   elseif (isa(varargin{2},'double'))
       s1=signal(t,varargin{2});
   end        
   if isa(varargin{3},'double')    
       offsetNull = 0;
       tdebfin=varargin{3};       
   elseif ischar(varargin{3})
       if (strcmp(varargin{3},'offsetNull'))
           offsetNull=1;
           tdebfin=[1];
       elseif (strcmp(varargin{3},'withoffset'))
           offsetNull=0;
           tdebfin=[1];
       else
           error('Wrong ''offset'' keyword argument')
       end
    else
       error('Wrong type of input arguments')
    end
    paramPwelch={[],[],[]};
   
case 4    
    %4 aruments d'entrées : 1 objet test, 1 objet signal,O offset ou pas, iinter 
     if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
    else
        error('1st argument is not a test object');
     end
    
     if isa(varargin{2},'signal')
         s1=varargin{2};
     elseif isa(varargin{2},'double')
        s1=signal(t,varargin{2});
     else 
           error('2nd argument is not a signal or a double')
     end
    if ischar(varargin{3})
        if (strcmp(varargin{3},'offsetNull'))
           offsetNull=1;
           tdebfin=[1];
       elseif (strcmp(varargin{3},'withoffset'))
           offsetNull=0;
           tdebfin=[1];
       else
           error('Wrong ''offset'' keyword argument')
       end
    else
        error('2nd argument is not a string');
    end
     if (isa(varargin{4},'double') )
       tdebfin=varargin{4};   
    else
        error('3rd argument is not of type ''double'' ');
     end
     paramPwelch={[],[],[]};

case 5       
     if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
     else
        error('1st argument is not a test object');
     end    
     if isa(varargin{2},'signal')
         s1=varargin{2};
     elseif isa(varargin{2},'double')
        s1=signal(t,varargin{2});
     else 
           error('2nd argument is not a signal or a double')
     end    
     if ischar(varargin{3})
        if (strcmp(varargin{3},'offsetNull'))
           offsetNull=1;
           tdebfin=[1];
       elseif (strcmp(varargin{3},'withoffset'))
           offsetNull=0;
           tdebfin=[1];
       else
           error('Wrong ''offset'' keyword argument')
        end
     else
        error('3rd argument is not a string');
     end
     if (isa(varargin{4},'double') )
        tdebfin=varargin{4};   
     else
        error('4th argument is not of type ''double'' ');
     end

     if (isa(varargin{5},'cell') )
       paramPwelch=varargin{5};   
     else
        error('5th argument is not of type ''cell'' ');
     end   
    otherwise
     error('Wrong number of input arguments')
end
%------------------------------------------------------------------------
%------------------------------------------------------------------------
tex = sprintf('Calculating RAO - Project : %s - Test n°%d ...',get(t,'name'),get(t,'num'));
disp(tex);

fmeas = get(t,'fileMeas');
fres = get(t,'fileRes');
chan = get(t,'channelNames');
unit = get(t,'channelUnits');
%paramNum = get(t,'paramNum');
typ=TESTGetParamNum(t,'Type');
Ttheo=TESTGetParamNum(t,'Tp');
[tdeb1 tfin1]=TESTGetInterval(t);
if exist(fres) == 2
    load(fres); 
end

% initializing the signals for each channel
data1 = load(get(t,'fileMeas'));
dt=data1(2,1) - data1(1,1);
nn=get(t,'channelNames');
uu=get(t,'channelUnits');
for ich = 1 : length(chan)    
    stab(ich) = signal(data1(:,ich+1),dt,nn{ich},uu{ich});          
end


for iinter=tdebfin;
    
    tdeb=tdeb1(iinter);
    tfin=tfin1(iinter);
    clear TFmod1;
    clear TFpha1;
    clear TFdsp1;

    for ich = 1:length(chan)
    %   s = signal(t,ich);
        if (typ == 1)   %Regular Wave case
            sCut = SIGcut(stab(ich),tdeb,tfin,Ttheo);
            SFfreq1=SFfreq{iinter};    
            SFmod1=SFmod{iinter};
            SFpha1=SFpha{iinter};
            icol=find(ismember(get(t,'channelNames'),get(s1,'nom')));
            TFuncmod1=SFmod1(1,:)/SFmod1(1,icol);
            TFuncpha1=SFpha1(1,:)-ones*SFpha1(1,icol);
            for itfunc=1:length(TFuncpha1)
                if TFuncpha1(itfunc)<-pi
                   TFuncpha1(itfunc)=TFuncpha1(itfunc)+2*pi;
                elseif TFuncpha1(itfunc)>pi
                   TFuncpha1(itfunc)=TFuncpha1(itfunc)-2*pi;
                end
            end
            TCoherfreq1=[];
            TCohermod1=[];
            val(:,1)=SFfreq1(1);

        else  %irregular or decay tests cases
            sCut = SIGcut(stab(ich),tdeb,tfin);
            val = SIGTransFunc(SIGcut(s1,tdeb,tfin),sCut,offsetNull,paramPwelch,0);
            TFuncmod1(:,ich) = val(:,2);
            TFuncpha1(:,ich) = val(:,3);
            TCoherfreq1(:,ich) = val(:,4);
            TCohermod1(:,ich) = val(:,5);
        end
    end
    TFuncfreq{iinter} = val(:,1);
    TFuncmod{iinter}=TFuncmod1;
    TFuncpha{iinter}=TFuncpha1;
    TCohermod{iinter}=TCohermod1;
    TCoherfreq{iinter}=TCoherfreq1;
    Pwelchparam{iinter}=paramPwelch;
    SigRefName{iinter}=get(s1,'nom');

    tstart(iinter)=tdeb;
    tend(iinter)=tfin;

    if exist(fres) == 2
    save(fres,'tstart','tend','TFuncfreq','TFuncmod','TFuncpha','TCoherfreq', 'TCohermod','Pwelchparam','SigRefName','-append');
    else
    save(fres,'tstart','tend','TFuncfreq','TFuncmod','TFuncpha','TCoherfreq', 'TCohermod','Pwelchparam','SigRefName');
    end

end
tex = sprintf('\b Done');
disp(tex);
end


