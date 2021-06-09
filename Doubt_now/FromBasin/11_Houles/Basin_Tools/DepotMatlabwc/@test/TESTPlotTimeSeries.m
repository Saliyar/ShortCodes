function TESTPlotTimeSeries (varargin)
%function of class TEST
%Display the time series of the test given in input
%If printarg == 'pdf', the time series graphs are saved in a pdf file
%
%Syntax :
%PlotTimeSeries(test,printarg)


%testing input arguments----------------------------------------
switch nargin
case 1 
    if isa(varargin{1},'test')
        te = varargin{1};   %Initialisation of test
        printarg = 0;
    else
        error('1st argument is not a test object');
    end
case 2
    if isa(varargin{1},'test')
       if strcmp(varargin{2},'pdf') 
        te = varargin{1};   %Initialisation of test
        printarg = 1;
       else
            error('wrong printing argument');
       end
    else
        error('1st argument is not a test object');
    end   
end

tex = sprintf('Plotting time series - Project : %s - Test n°%d ...',get(te,'name'),get(te,'num'));
disp(tex);

%Load data and parameters---------------------------------------
data=load(char(strcat(get(te,'fileMeas'))));

numt = get(te,'num');

paramName=get(te,'paramNames');
paramNum=get(te,'paramNum');
paramStr=get(te,'paramStr');
pathfigure=(get(te,'pathFig'));
groups=cell2mat(get(te,'channelGroups'));
channam=get(te,'channelNames');
chanunit=get(te,'channelUnits');

[tdeb tfin]=TESTGetInterval(te);

if length(tdeb)<1
   tdeb=data(1,1);
   tfin=data(end,1);
end

indBoard=1; %index number of the board
for kj=1:max(groups);
    indNum=find(groups==indBoard); %search index number in test.groups 
    board(1:length(indNum),kj)=indNum; % index number of graph for each board
    nbGraphBoard(kj)=length(indNum); %total number of graph for each board
    indBoard=indBoard+1;
end;
dec=1;

IndTimeBegin=find(data(:,1)==tdeb(1)); %search begin time of analysis
IndTimeLast=find(data(:,1)==tfin(1)); %search last time of analysis

    

for ki=1:size(board,2); % loop for plotting each board
    figure('PaperType','A4','Units', 'centimeters', 'Position', [3+ki 6 14 19.8]);
    zoom on; hold on; 
    %Board title construction and display---------------------------
    subplot(nbGraphBoard(ki)+1,1,1);
    axis off;
    titleligne1=[get(te,'name') '  -  test n°' num2str(get(te,'num')) ' - Time signals'];
%    typ=paramNum(4);
    typ=TESTGetParamNum(te,'Type');
    switch typ
        case 0
            texttyp = ' ';
        case 1
            texttyp=['Regular waves   -   H=' num2str(TESTGetParamNum(te,'Hs'),'%.3f') 'cm  -  T=' num2str(TESTGetParamNum(te,'Tp'),'%.3f') 's' ];
        case 2
            texttyp=['Irregular waves   -   Hs=' num2str(TESTGetParamNum(te,'Hs'),'%.3f') 'cm  -  Tp=' num2str(TESTGetParamNum(te,'Tp'),'%.3f') 's  -  Gamma=' num2str(TESTGetParamNum(te,'Gamma'),'%.1f')];
            %texttyp=['Irregular waves   -   Hs=' num2str(TESTGetParamNum(te,'Hs')) 'cm  -  Tp=' num2str(TESTGetParamNum(te,'Tp')) 's'];
        case 3
            texttyp=['Decay test'];
        case 4
            %namefile=char(paramStr(7));
            namefile=char(TESTGetParamString(te,'Target File'));
            texttyp=['Target file: ' namefile];
        case 5
            texttyp=['Wind only test' num2str(TESTGetParamNum(te,'Wind speed')) 'm/s'];
    end;       
    titleligne2=[texttyp ' - Config : ' num2str(TESTGetParamString(te,'Config'))];
   % titleligne3=['Comment: ' char(paramStr(11))];
  
    titleligne3=['Comments: ' TESTGetParamString(te,'Comments')];
    titleligne4=['tstart='  num2str(tdeb(1)) ' s, tend=' num2str(tfin(1)) ' s'];
    %titleFull = strvcat(titleligne1, titleligne2, titleligne3);
    
    %axes('Position',[0.1 0.95 0.8 0.05],'Color','r');
    
    text (0.5,0.8,titleligne1,'HorizontalAlignment','Center','FontSize',11,'Interpreter','None');
    text (0.5,0.5,titleligne2,'HorizontalAlignment','Center','FontSize',9,'Interpreter','None');
    text (0.5,0.2,titleligne3,'HorizontalAlignment','Center','FontSize',8,'Interpreter','None');
    text (0.5,0,titleligne4,'HorizontalAlignment','Center','FontSize',8,'Interpreter','None');
    for kj=1:nbGraphBoard(ki); %loop for plotting each graph
        graph(kj)=subplot(nbGraphBoard(ki)+1,1,kj+1);
        set(graph(kj),'Fontsize',8);
        plot(data(:,1),data(:,1+board(kj,ki)),'Color',[0.6 0.6 0.6]);
        hold on;
        plot(data(IndTimeBegin:IndTimeLast,1),data(IndTimeBegin:IndTimeLast,1+board(kj,ki)),'Color',[1 0 0]);
        ylabel(strcat(char(channam(board(kj,ki))),'(',char(chanunit(board(kj,ki))),')'),'Fontsize',8,'Interpreter','None');

    end;
    
    linkaxes (graph, 'x');
    xlabel('time (s)');
    dec=dec+1;
    if printarg==1;
        namefigure=strcat(get(te,'pathFig'),'TimeSeries_',get(te,'name'),'_',num2str(numt),'_',num2str(ki),'.pdf');
        orient tall;
        print ('-dpdf', namefigure);
    end; 
end
tex = sprintf('\b Done');
disp(tex);
end

