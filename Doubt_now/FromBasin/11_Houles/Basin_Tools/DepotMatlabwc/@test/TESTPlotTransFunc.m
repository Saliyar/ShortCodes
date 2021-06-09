function TESTPlotTransFunc(varargin)
%function of class TEST
%Reads the result file and plot the frequency data.
%Syntax :
%TESTPlotTransFunc(test,printpdf)
%TESTPlotTransFunc(test,printpdf,[indinterval])
%TESTPlotTransFunc(test,printpdf,[indinterval],[freqmin freqmax])

%testing input arguments----------------------------------------
switch nargin
case 1 
    if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
        printarg = 0;
        tdebfin=[1];
        freqmin=1/5;
        freqmax=2;
    else
        error('1st argument is not a test object');
    end
case 2
    if (isa(varargin{1},'test') && ischar(varargin{2}))
        t = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{2},'pdf');
        tdebfin=[1];
        freqmin=1/5;
        freqmax=2;
        
    else
        error('1st argument is not a test object');
    end
    
case 3    
     if (isa(varargin{1},'test') && ischar(varargin{2}) && isa(varargin{3},'double'))
        t = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{2},'pdf');
        tdebfin=varargin{3};
        fr1=varargin{3};
        freqmin=fr1(1);
        freqmax=fr1(2);
    else
        error('1st argument is not a test object');
    end
    
    
case 4    
     if (isa(varargin{1},'test') && ischar(varargin{2}) && isa(varargin{3},'double') && isa(varargin{4},'double'))
        t = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{2},'pdf');
        tdebfin=varargin{3};
        tdebfin
        fr1=varargin{4};
        freqmin=fr1(1);
        freqmax=fr1(2);
    else
        error('1st argument is not a test object');
    end
    
end

tex = sprintf('Plotting RAO - Project : %s - Test n°%d ...',get(t,'name'),get(t,'num'));
disp(tex);

%Load data and parameters---------------------------------------  
numt = get(t,'num');
fmeas = get(t,'fileMeas');
fres = get(t,'fileRes');
chan = get(t,'channelNames');
unit = get(t,'channelUnits');
grou = cell2mat(get(t,'channelGroups'));
grouf = cell2mat(get(t,'channelGroupsFreq'));
%para = get(t,'param');
paramNum = get(t,'paramNum');
paramNames = get(t,'paramNames');
paramStr = get(t,'paramStr');

 

%paramet=get(t,'parameters');
load(fres);

Ttheo=TESTGetParamNum(t,'Tp');
%[tdeb1 tfin1]=TESTGetInterval(t);
%loading 'tstart' and 'tend' from result file (in order to check the
%interval used)
tdeb1=tstart;
tfin1=tend;


for iinter=1:length(tdebfin)
  tdeb=tdeb1(tdebfin(iinter));
  tfin=tfin1(tdebfin(iinter));
  if (tdeb==tfin)
      error('tdeb and tfin are not correctly defined in excel file');
  end
  
  TFuncfreq1=TFuncfreq{iinter};
  TFuncmod1=TFuncmod{iinter};
  TFuncpha1=TFuncpha{iinter};
  TCoherfreq1=TCoherfreq{iinter};
  TCohermod1=TCohermod{iinter};
  SigRefName1=SigRefName{iinter};
  s1=signal(t,SigRefName1);
  
  indminfreq=find(TFuncfreq1(:,1)>=freqmin,1,'first');
  indmaxfreq=find(TFuncfreq1(:,1)>=freqmax,1,'first');
  if (indminfreq>=indmaxfreq)
      error('freqmin and freqmax are not well defined');      
  end
%   TFfreq1=TFfreq{iinter};
%   TFmod1=TFmod{iinter};
%   TFpha1=TFpha{iinter};
%   TFdsp1=TFdsp{iinter};
%   
%   Pwelchfreq1=Pwelchfreq{iinter};
%   Pwelchdsp1=Pwelchdsp{iinter};
   Pwelchparam1=Pwelchparam{iinter}; 
  Window=Pwelchparam1{1};
  if length(Window)>1
     Window=length(Window); 
  end
  if length(Window)==0
      Windowtxt= 'default';
  else
      Windowtxt=num2str(Window);
  end
  
  Covering=Pwelchparam1{2};;
  if length(Covering)==0
      Coveringtxt= 'default';
  else 
      Coveringtxt= num2str(Covering);
  end
  NFFT=Pwelchparam1{3};;
  if length(NFFT)==0
      NFFTtxt= 'default';
  else
      NFFTtxt=num2str(NFFT);
  end
  
  
  indBoard=1; %index number of the board
for kj=1:max(grouf);
    indNum=find(grouf==indBoard); %search index number in test.groups 
    board(1:length(indNum),kj)=indNum; % index number of graph for each board
    nbGraphBoard(kj)=length(indNum); %total number of graph for each board
    indBoard=indBoard+1;
end;

for ki=1:size(board,2); % loop for plotting each board
    figure('PaperType','A4','Units', 'centimeters', 'Position', [3+ki 1 14 19.8]);
    zoom on; hold on;     
    %Board title construction and display---------------------------
    subplot((nbGraphBoard(ki)+1),1,1);
    axis off;
    titleligne1=[get(t,'name') '  -  test n°' num2str(get(t,'num')) ' - RAO'];
    typ=TESTGetParamNum(t,'Type');
    switch typ
        case 1
            error('The function TESTPlotTransFunc.m is not a suitable function for regular-wave tests')
        case 2
            texttyp=['Irregular waves   -   Hs=' num2str(TESTGetParamNum(t,'Hs')) 'm  -  Tp=' num2str(TESTGetParamNum(t,'Tp')) 's  -  Gamma=' num2str(TESTGetParamNum(t,'Gamma'))];            
        case 3
             error('The function TESTPlotTransFunc.m is not a suitable function for decay tests')
        case 4
            namefile=char(TESTGetParamString(t,'Target File'));
            texttyp=['Target file: ' namefile];
    end;    
  
    titleligne2=[texttyp];
    titleligne3=['Comments: ' TESTGetParamString(t,'Comments')];
    if (typ==2 | typ==4)
        titleligne5=['Periodogram Window = ' Windowtxt ' pts , Overlap = ' Coveringtxt , ' pts, NFFT Pwelch = ' NFFTtxt ' pts'];
    end;
    titleligne4=['tstart='  num2str(tdeb1(iinter)) ' s, tend=' num2str(tfin1(iinter)) ' s' ]; 
       
    text (0.5,1,titleligne1,'HorizontalAlignment','Center','FontSize',11);
    text (0.5,0.7,titleligne2,'HorizontalAlignment','Center','FontSize',9);
    text (0.5,0.5,titleligne3,'HorizontalAlignment','Center','FontSize',8);
    text (0.5,0.3,titleligne4,'HorizontalAlignment','Center','FontSize',8);  
    if (typ==2 | typ==4)
        text (0.5,0.1,titleligne5,'HorizontalAlignment','Center','FontSize',8);
    end
    for kj=1:nbGraphBoard(ki); %loop for plotting each graph
%         graph(kj,1)=subplot(nbGraphBoard(ki)+1,2,(2*kj-1)+1);
%         set(graph(kj,1),'Fontsize',8);       
%         hold on; grid on;      
%         xlim([0 5]);
        
        %Irregular waves and specific wave-group tests---------------------------------------------
        if (typ==2 | typ ==4)
        graph(kj,1)=subplot((nbGraphBoard(ki)+1),2,(kj-1)*2+1+2);
        set(graph(kj,1),'Fontsize',8);       
        hold on; grid on;      
        %xlim([0 5]);
            if kj==1
                title('RAO - Amplitude')
            end
            plot(TFuncfreq1(indminfreq:indmaxfreq),TFuncmod1(indminfreq:indmaxfreq,board(kj,ki)),'b');
            hold on;
            plot(TCoherfreq1(:,1),TCohermod1(:,board(kj,ki))/max(TCohermod1(:,board(kj,ki)))*max(TFuncmod1(indminfreq:indmaxfreq,board(kj,ki))),'--k');
            
            yl = sprintf('%s\n(%s / %s)',chan{board(kj,ki)},unit{board(kj,ki)},get(s1,'unite'));
            %ylabel([chan{board(kj,ki)} ' (' unit{board(kj,ki)} '^2/Hz)']);
            ylabel(yl);
            xlim([freqmin freqmax]); %ylim([0 1.5*max(Pwelchdsp1(:,board(kj,ki)))]);v = axis; 
            if (kj)==nbGraphBoard(ki)
            xlabel('freq (Hz)');
            end
            graph(kj,1)=subplot((nbGraphBoard(ki)+1),2,kj*2+2);
            set(graph(kj,1),'Fontsize',8);       
            hold on; grid on;      
            %xlim([0 5]);
             if kj==1
                title('RAO - Phase (°)')
            end
            plot(TFuncfreq1(indminfreq:indmaxfreq),TFuncpha1(indminfreq:indmaxfreq,board(kj,ki))/pi*180,'b');
            hold on;
            plot(TCoherfreq1(:,1),TCohermod1(:,board(kj,ki))/max(TCohermod1(:,board(kj,ki)))*max(TFuncpha1(indminfreq:indmaxfreq,board(kj,ki))/pi*180),'--k');

            
            yl = sprintf('%s\n(%s / %s)',chan{board(kj,ki)},unit{board(kj,ki)},get(s1,'unite'));
            %ylabel([chan{board(kj,ki)} ' (' unit{board(kj,ki)} '^2/Hz)']);
            %ylabel(yl);
            xlim([freqmin freqmax]); %ylim([0 1.5*max(Pwelchdsp1(:,board(kj,ki)))]);v = axis;    
            legend('RAO', 'Coherence');
        end
        
    end
    linkaxes (graph, 'x');
    xlabel('freq (Hz)');
    if printarg==1
    namefigure=strcat(get(t,'pathFig'),'RAO_',get(t,'name'),'_',num2str(numt),'_',num2str(ki),'_',num2str(iinter),'.pdf');
    orient tall;
    set(gcf, 'Renderer', 'painters');
    print ('-dpdf', namefigure);
    end
end 
end
    tex = sprintf('\b Done');
    disp(tex);
end


