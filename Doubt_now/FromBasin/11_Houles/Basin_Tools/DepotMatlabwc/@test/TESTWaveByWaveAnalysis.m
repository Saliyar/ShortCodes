function TESTWaveByWaveAnalysis(varargin)
%TESTWaveByWaveAnalysis utilise la fonction de Félicien Bonnefoy
%[up down] = wbw_analysis(time, data, t_start, x, depth)
%
%
switch nargin
    case 1
        
        if isa(varargin{1},'test')
            t = varargin{1};   %Initialisation of test
        else
            error('1st argument is not a test object');
        end
        
    case 2
        if isa(varargin{1},'test')
            t = varargin{1};   %Initialisation of test
        else
            error('1st argument is not a test object');
        end
        
        info = varargin{2};
        
    otherwise
        error('Wrong number of input arguments')
end


filterState = 'low';        % 'band', 'high', 'stop'
f1 = 7;
f2 = 100;

msg = sprintf('Wave by wave analysis ...    %s test n°%d ...',get(t,'name'),get(t,'num'));
disp(msg);

fmeas = get(t,'fileMeas');
fres = get(t,'fileRes');
chan = get(t,'channelNames');
unit = get(t,'channelUnits');
paramNum = get(t,'paramNum');

Ttheo=TESTGetParamNum(t,'Tp');
[tdeb1 tfin1]=TESTGetInterval(t);

info.tdeb = tdeb1(1);
info.tfin = tfin1(1);  

twindow = info.tfin - info.tdeb;


Res.nPeriod = floor(twindow/info.Ttheo);
Res.tfin = info.tdeb+Res.nPeriod*info.Ttheo;

% initializing the signals for each channel
data1 = load(get(varargin{1},'fileMeas'));
dt=data1(2,1) - data1(1,1);
time = data1(:,1);
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
        s = SIGcut(stab(ich),info.tdeb,Res.tfin); 
        sig = get(s,'Y');
        sig2 = sig - mean(sig(1 : 500));
        IIsel1 = (time<Res.tfin);
        IIsel2 = (time>=info.tdeb);
        IIsel = find(IIsel1.*IIsel2);
        timecut = time(IIsel); 
        ResAna = dofilterandfftOnSignal(timecut , sig2, filterState, f1, f2, info, Res.nPeriod);
        %Res=fillMainStructwithRes(Res, ResAna,'SigWaves');
        %clear ResAna;
        
        
        [u , d] = wbw_analysis(time, ResAna.DataFiltered);
        
        up(ich) = u;
        down(ich) = d;
        
    end
    
    tstart(iinter)=tdeb;
    tend(iinter)=tfin;
    
    if exist(fres) == 2
        save(fres,'tstart','tend','up','down','-append');
    else
        save(fres,'tstart','tend','up','down');
    end
    
end

tex = sprintf('\b Done');
disp(tex);

end

