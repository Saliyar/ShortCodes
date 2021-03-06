function PROJPlotReportGraphs(varargin)
%function of class PROJ
%Reads the result file and plot the frequency data.
%Syntax :
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... })
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },[freqWindow])
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },'pdf')
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },'pdf',[freqWindow])
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },[freqWindow],'pdf')
%{testlist1,testlist2, ... } : cell array of testlists, one for each
%configuration

%testing input arguments--------------------------------------------------
%-------------------------------------------------------------------------
switch nargin
case 2
    if (isa(varargin{1},'project') && isa(varargin{2},'cell'))
        p = varargin{1}; %Initialisation of test
        printarg = 0;
        freqmin=1/5;
        freqmax=2;
        testlist=varargin{2};        
    else
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end    
case 3    
     if (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{3},'double'))
        p = varargin{1};   %Initialisation of test
        printarg = 0;
        fr1=varargin{3};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
        
     elseif (isa(varargin{1},'project') && isa(varargin{2},'cell') && ischar(varargin{3}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{3},'pdf');
        freqmin=1/5;
        freqmax=2;
        testlist=varargin{2};
     else    
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end
        
case 4    
    if (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{3},'double') && ischar(varargin{4}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{4},'pdf');
        fr1=varargin{3};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
        
     elseif (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{4},'double') && ischar(varargin{3}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{3},'pdf');
        fr1=varargin{4};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
     else    
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end
    
end

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

tex = sprintf('Plotting RAOs - Project : %s',get(p,'name'));
disp(tex);

coul={'b','k','g','m','c'};
linestyle={'-','--','-.',':','-'};
markstyle={'o','^','s','*','.'};
linsize=[0.5 0.5 0.5 0.5 0.5];

%On parcourt les listes d'essais une par une ------------------------------
%--------------------------------------------------------------------

for iconfig=1:length(testlist)  
    numtest=cell2mat(testlist(iconfig));  
    %On parcourt les tests de la premiere liste
    for itest=numtest 
        t=test(p,itest);
        %Load data and parameters---------------------------------------  
        numt = get(t,'num');
        fmeas = get(t,'fileMeas');
        fres = get(t,'fileRes');
        chan = get(t,'channelNames');
        unit = get(t,'channelUnits');
        grou = cell2mat(get(t,'channelGroups'));
        grouf = cell2mat(get(t,'channelGroupsFreq'));
        typ=TESTGetParamNum(t,'Type');
        Ttheo=TESTGetParamNum(t,'Tp');
        load(fres);
        
        %[tdeb1 tfin1]=TESTGetInterval(t);
        %loading 'tstart' and 'tend' from result file (in order to check the
        %interval used)
        tdeb1=tstart;
        tfin1=tend;
        
        %Boucle sur les intervalles d'analyse
        for iinter=1
            tdeb=tdeb1(1);
            tfin=tfin1(1);
            if (tdeb==tfin)
                error('tstart and tend are not correctly defined in excel file');
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
            if (indminfreq>indmaxfreq)
                error('freqmin and freqmax are not well defined');      
            end
  
            %-----------------------------------------------------------
            %Repartition des voies sur les boards-----------------------
            
            indBoard=1; %index number of the board
            for kj=1:max(grouf);
                indNum=find(grouf==indBoard);       %search index number in test.groups 
                board(1:length(indNum),kj)=indNum;  %index number of graph for each board
                nbGraphBoard(kj)=length(indNum);    %total number of graph for each board
                indBoard=indBoard+1;
            end;
            
            %Loop for plotting each board--------------------------------
            for ki=1:size(board,2); 
                %On ouvre une nouvelle figure si c'est la premi�re config
                %et le premier test
                if (iconfig==1 && itest==numtest(1))
                    fignum(ki)=figure('PaperType','A4','Units', 'centimeters', 'Position', [3+3*ki 6 14 19.8]);
                else
                    %Sinon on rappelle la figure
                    figure(fignum(ki));
                end
                %zoom on; 
                hold on;     
                %Board title construction and display---------------------------
                subplot((nbGraphBoard(ki)+1),1,1);
                axis off;
   
                titleligne1=[get(t,'name') '  -  Report Graphs - RAO'];
                
                                
                text (0.5,1,titleligne1,'HorizontalAlignment','Center','FontSize',11);
%                 text (0.5,0.7,titleligne2,'HorizontalAlignment','Center','FontSize',9);
%                 text (0.5,0.5,titleligne3,'HorizontalAlignment','Center','FontSize',8);
%                 text (0.5,0.3,titleligne4,'HorizontalAlignment','Center','FontSize',8);  

                
                

                for kj=1:nbGraphBoard(ki); %loop for plotting each graph
            %         graph(kj,1)=subplot(nbGraphBoard(ki)+1,2,(2*kj-1)+1);
            %         set(graph(kj,1),'Fontsize',8);       
            %         hold on; grid on;      
            %         xlim([0 5]);

                    %Irregular waves and specific wave-group tests---------------------------------------------
                    
                    graph(kj,1)=subplot((nbGraphBoard(ki)+1),2,(kj-1)*2+1+2);
                    set(graph(kj,1),'Fontsize',8);       
                    hold on; grid on;      
                    %xlim([0 5]);
                    if kj==1
                            title('RAO - Amplitude')
                    end
                    if (typ==2 || typ ==4)     
                        plot(TFuncfreq1(indminfreq:indmaxfreq),TFuncmod1(indminfreq:indmaxfreq,board(kj,ki)),[linestyle{iconfig} coul{iconfig}],'linewidth',linsize(iconfig));
                        %leg = sprintf('
                    elseif (typ==1)
                        plot(TFuncfreq1(1),TFuncmod1(1,board(kj,ki)),[coul{iconfig} markstyle{iconfig}],'markerfacecolor',coul{iconfig},'markersize',3 );
                    else
                       error('wrong type of test for PROJPlotTransFunc.m') 
                    end
                    hold on;
                    %plot(TCoherfreq1(:,1),TCohermod1(:,board(kj,ki))/max(TCohermod1(:,board(kj,ki)))*max(TFuncmod1(indminfreq:indmaxfreq,board(kj,ki))),'--k');
          
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
                        title('RAO - Phase (�)')
                    end
                    if (typ==2 | typ ==4)     
                        plot(TFuncfreq1(indminfreq:indmaxfreq),TFuncpha1(indminfreq:indmaxfreq,board(kj,ki))*180/pi,[linestyle{iconfig} coul{iconfig}],'linewidth',linsize(iconfig));
                    elseif (typ==1)
                        plot(TFuncfreq1(1),TFuncpha1(1,board(kj,ki))*180/pi,[coul{iconfig} markstyle{iconfig}],'markerfacecolor',coul{iconfig},'markersize',3 );
                    else
                        error('wrong type of test for PROJPlotTransFunc.m') 
                    end
                    hold on;
                    %plot(TCoherfreq1(:,1),TCohermod1(:,board(kj,ki))/max(TCohermod1(:,board(kj,ki)))*max(TFuncpha1(indminfreq:indmaxfreq,board(kj,ki))),'--k');

                    yl = sprintf('%s\n(%s / %s)',chan{board(kj,ki)},unit{board(kj,ki)},get(s1,'unite'));
                    %ylabel([chan{board(kj,ki)} ' (' unit{board(kj,ki)} '^2/Hz)']);
                    %ylabel(yl);
                    xlim([freqmin freqmax]);
                    ylim([-180 180])
                    %ylim([0 1.5*max(Pwelchdsp1(:,board(kj,ki)))]);v = axis;    
                    %legend('RAO', 'Coherence')       
                end %kj=1:nbGraphBoard(ki);
                
                linkaxes (graph, 'x');
                xlabel('freq (Hz)');
                if (printarg==1 && iconfig==length(varargin{2}) && (itest==numtest(end)))
                    namefigure=strcat(get(t,'pathFig'),'Global_RAO_',get(p,'name'),'_',num2str(ki),'.pdf');
                    orient tall;
                    print ('-dpdf', namefigure);
                end
            end
        end
    end %itest
end %iconfig
    
    
tex = sprintf('\b Done');
disp(tex);
end


