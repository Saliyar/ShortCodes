function TESTPlotAnaFreq(varargin)
%function of class TEST
%Reads the result file and plot the frequency data.
%Syntax :
%TESTPlotAnaFreq(test,printpdf)
%


%testing input arguments----------------------------------------
switch nargin
case 1 
    if isa(varargin{1},'test')
        t = varargin{1};   %Initialisation of test
        printarg = 0;
        tdebfin=[1];
    else
        error('1st argument is not a test object');
    end
case 2
    if (isa(varargin{1},'test') && ischar(varargin{2}))
        t = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{2},'pdf');
        tdebfin=[1];
    else
        error('1st argument is not a test object');
    end
    
case 3    
     if (isa(varargin{1},'test') && ischar(varargin{2}) && isa(varargin{3},'double'))
        t = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{2},'pdf');
        tdebfin=varargin{3};
    else
        error('1st argument is not a test object');
    end
    
end

tex = sprintf('Plotting Frequency Analysis - Project : %s - Test n°%d ...',get(t,'name'),get(t,'num'));
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


for iinter=tdebfin
  tdeb=tdeb1(iinter);
  tfin=tfin1(iinter);
  if (tdeb==tfin)
      error('tdeb and tfin are not correctly defined in excel file');
  end
  
  TFfreq1=TFfreq{iinter};
  TFmod1=TFmod{iinter};
  TFpha1=TFpha{iinter};
  TFdsp1=TFdsp{iinter};
  
  Pwelchfreq1=Pwelchfreq{iinter};
  Pwelchdsp1=Pwelchdsp{iinter};
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

% loop for plotting each board------------------------------------------------------
%-----------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------
for ki=1:size(board,2);
    figure('PaperType','A4','Units', 'centimeters', 'Position', [16+ki 6 14 19.8]);
    zoom on; hold on;     
%Board title construction and display------------------------------------------
    subplot(nbGraphBoard(ki)+1,1,1);
    axis off;
    typ=TESTGetParamNum(t,'Type');
    switch typ
        case 1
            texttyp=['Regular waves   -   H=' num2str(TESTGetParamNum(t,'Hs')) ' m  -  T=' num2str(TESTGetParamNum(t,'Tp')) 's' ];
            titleligne1=[get(t,'name') '  -  test n°' num2str(get(t,'num')) ' - Harmonic Analysis and FFT Amplitude'];
        case 2
            texttyp=['Irregular waves   -   Hs=' num2str(TESTGetParamNum(t,'Hs')) ' m  -  Tp=' num2str(TESTGetParamNum(t,'Tp')) 's  -  Gamma=' num2str(TESTGetParamNum(t,'Gamma'))];
            titleligne1=[get(t,'name') '  -  test n°' num2str(get(t,'num')) ' - Power Spectral Density'];         
        case 3
            texttyp=['Decay test'];
        case 4
            %namefile=char(paramStr(7));
            namefile=char(TESTGetParamString(t,'Target File'));
            texttyp=['Target file: ' namefile];
            titleligne1=[get(t,'name') '  -  test n°' num2str(get(t,'num')) ' - Power Spectral Density'];
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
    
%loop for plotting each graph-------------------------------------------
    for kj=1:nbGraphBoard(ki); 
        graph(kj)=subplot(nbGraphBoard(ki)+1,1,kj+1);
        set(graph(kj),'Fontsize',12);       
        hold on; grid on;      
        xlim([0 5]);
        %Regular wave case-------------------------------------------------
        if typ == 1                 
            SFfreq1=SFfreq{iinter};
            SFmod1=SFmod{iinter};
            SFpha1=SFpha{iinter};
      
            bar(TFfreq1,TFmod1(:,board(kj,ki)),'c','EdgeColor','c');
            plot(SFfreq1,SFmod1(:,board(kj,ki)),'ro');
            ylabel([chan{board(kj,ki)} ' (' unit{board(kj,ki)} ')']);
            chaine =[];%construction de la chaine
            for ordre=1:length(SFfreq1)              
                ch=sprintf(['ordre %i = %.3f (' unit{board(kj,ki)} ')  %.3f (Hz)\n'],ordre,SFmod1(ordre,board(kj,ki)),SFfreq1(ordre)); %modifie le 20/02/2015 par A. Tassin
                chaine = [chaine ch];
            end                
            v = axis; 
            
            posx = v(2)*0.6;
           % posy = max(SFmod(:,board(kj,ki)))*0.5; %modifie le 20/02/2015
           % par A. Tassin
            posy = v(4)*0.5;
            text(posx,posy,chaine,'fontsize',10);
%             if kj == 1
%                 legend('FFT modulus','Fourier Series Coef.','Location','NorthOutside');
%             end
        end
        %Irregular wave case---------------------------------------------
        if (typ==2 | typ ==4)           
             
            hcolorbar=bar(TFfreq1,TFdsp1(:,board(kj,ki)));
            set(hcolorbar,'FaceColor','Cyan','Edgecolor','Cyan');%,'EdgeColor','r'
            plot(Pwelchfreq1,Pwelchdsp1(:,board(kj,ki)),'b')                      
            if ((board(kj,ki) == 1 | board(kj,ki) == 2) && typ==2)
                %Theoretical Jonswap spectrum calculation
                Hs = TESTGetParamNum(t,'Hs')*1000;
                Tp = TESTGetParamNum(t,'Tp');
                gamma = TESTGetParamNum(t,'Gamma');
                %frqmin = 1/3.5;        %parametres du batteur
                frqmin = 1/3; 
                %frqmax = 1/0.8;    
                frqmax = 1/0.5;   
                df = TFfreq1(2) - TFfreq1(1);
                freqc = [frqmin:df:frqmax];
                alpha = ajonswap(Tp,Hs,gamma);
                spectreJonswap = vjonswap(freqc,Tp,Hs,gamma,alpha);
                plot(freqc,spectreJonswap,'r-','Linewidth',2);
                legend('measured raw DSP','PWELCH DSP','targeted Jonswap spectrum');
            else
                legend('measured raw DSP','PWELCH DSP');
            end
            
            yl = sprintf('%s\n(%s^2/Hz)',chan{board(kj,ki)},unit{board(kj,ki)});
            %ylabel([chan{board(kj,ki)} ' (' unit{board(kj,ki)} '^2/Hz)']);
            ylabel(yl);
            xlim([0 2]); 
            ylim([0 (1.5*max(Pwelchdsp1(:,board(kj,ki))))+0.01]);
            v = axis; 
            %v = axis; xlim([0 2]); ylim([0 v(4)]);
            %plot([frqmin frqmin],[0 v(4)],'r');
        end
        
    end
    linkaxes (graph, 'x');
    xlabel('freq (Hz)');
    if printarg==1
    namefigure=strcat(get(t,'pathFig'),'FreqAna_',get(t,'name'),'_',num2str(numt),'_',num2str(ki),'_',num2str(iinter),'.png');
    orient tall;
    set(gcf, 'Renderer', 'painters');
    print ('-dpng', namefigure);
    end
end 
end

tex = sprintf('\b Done');
disp(tex);
end


