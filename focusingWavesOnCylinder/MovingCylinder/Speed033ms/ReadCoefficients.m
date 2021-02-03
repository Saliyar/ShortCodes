function ReadCoefficients(foamStarmovgenfile,nStart,nEnd,D,U,lgd,nCases)

FigH = figure('Position', get(0, 'Screensize'));
for i=nStart:nEnd
     
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{20:end,1};
    foamStar_DragForce=data{20:end,3};
    idx=find(foamStar_dtForce1==30);
    
    plot(foamStar_dtForce1,foamStar_DragForce,'LineWidth',3);
    ylabel('Cd','FontSize',32,'interpreter','latex')
    xlabel('Time [s]','FontSize',32,'interpreter','latex')
    set(gca,'Fontsize',32)
    title(['Cd - Drag Coefficient '],'FontSize',32,'interpreter','latex')
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
         legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest');
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    grid on
    hold on
    
    
end


%% FFT of Drag coeffcient Time series 
% FigH = figure('Position', get(0, 'Screensize'));
for i=nStart:nEnd
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{20:end,1};
    foamStar_DragForce=data{20:end,3};
    idx=find(foamStar_dtForce1==30);
    %% Doing FFT of results 
    L=length(foamStar_dtForce1);
    Fs=1/(foamStar_dtForce1(2)-foamStar_dtForce1(1));
    Y=fft(foamStar_DragForce);
    P2=abs(Y/L);
    P1 = P2(1:L/2+1); 
    P1(2:end-1) = 2*P1(2:end-1); 
    foamStar_dtForce1(2)-foamStar_dtForce1(1)
    f = (Fs)*(0:(L/2))/L; 
    %Noting down the maximum value for Cd
    [maxPD,indx] = max(P1)
    maxCd(i)=maxPD;
    
    
    %Plot 
%     plot(f,P1,'LineWidth',3) 
%     title('Single-Sided Amplitude Spectrum of Drag Coefficient','FontSize',32,'interpreter','latex')
%     xlabel('f (Hz)','FontSize',32,'interpreter','latex')
%     ylabel('|P1(f)|','FontSize',32,'interpreter','latex')
%     xlim([0 1])
%          % legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
%          legend (lgd{:},'interpreter','latex','FontSize',32);
%    % legend(legendCell,...
%           % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
%     legend('boxon')
%     hold on
end

%% Plot Cd Coeffecient from FFT 
FigH = figure('Position', get(0, 'Screensize'));
fontsize=32;
 hhh=2;
markerSet='osp^>v<d*';
% colorOrder = get(gca,'ColorOrder');
cOrder = colormap(cbrewer('qual', 'Dark2', 8));
markersize = 32;
linewidth = 4;
rect = [3 5 30 18];
rect2 = [3 5 30 18];
rect3 = [3 5 20 16];
for i=nStart:nEnd
    scatter(nCases(i),maxCd(i),'d','LineWidth',25);
   % set(gca, 'xtick' , nCases, 'XTickLabel',lgd{:})
    ylabel('Cd','FontSize',32,'interpreter','latex')
    xlabel('TestCases','FontSize',32,'interpreter','latex')  
    grid on
    hold on
end
    % xticklabels(lgd{:})
    set(gca,'Fontsize',32)
    title(['Cd - Drag Coefficient'],'FontSize',32,'interpreter','latex')
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
          legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southeast');
   %legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    hold off


%% Plot Lift Coeffecient Time series

FigH = figure('Position', get(0, 'Screensize'));
for i=nStart:nEnd
     
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{20:end,1};
    foamStar_LiftForce=data{20:end,4};
    plot(foamStar_dtForce1,foamStar_LiftForce,'LineWidth',3);
    ylabel('Cl','FontSize',32,'interpreter','latex')
    xlabel('Time [s]','FontSize',32,'interpreter','latex')
    set(gca,'Fontsize',32)
    title(['Cl - Lift Coefficient '],'FontSize',32,'interpreter','latex')
         legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southeast');
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
    hold on
    
end



%% FFT of lift coeffcient Time series 
% FigH = figure('Position', get(0, 'Screensize'));
for i=nStart:nEnd
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    foamStar_dtForce1=data{20:end,1};
    foamStar_LiftForce=data{20:end,4};
    %% Doing FFT of results 
    L=length(foamStar_dtForce1);
    Fs=1/(foamStar_dtForce1(2)-foamStar_dtForce1(1));
    Y=fft(foamStar_LiftForce);
    P2=abs(Y/L);
    P1 = P2(1:L/2+1); 
    P1(2:end-1) = 2*P1(2:end-1); 
   f = (Fs)*(0:(L/2))/L; 
    
    % Estimating the Maximum frequency 
    [maxPD,indx] = max(P1);
    PeakFreq(i)=f(indx);
    
%     plot(f,P1,'LineWidth',3) 
%     title('Single-Sided Amplitude Spectrum of Lift Coefficient','FontSize',32,'interpreter','latex')
%     xlabel('f (Hz)','FontSize',32,'interpreter','latex')
%     ylabel('P1(f)','FontSize',32,'interpreter','latex')
%      xlim([0 10])
%           % legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southwest','NumColumns',2);
%            legend (lgd{:},'interpreter','latex','FontSize',32);
%    % legend(legendCell,...
%           % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
%     legend('boxon')
%     grid on
%     hold on
end

FigH = figure('Position', get(0, 'Screensize'));
fontsize=32;
 hhh=2;
markerSet='osp^>v<d*';
% colorOrder = get(gca,'ColorOrder');
cOrder = colormap(cbrewer('qual', 'Dark2', 8));
markersize = 32;
linewidth = 4;
rect = [3 5 30 18];
rect2 = [3 5 30 18];
rect3 = [3 5 20 16];
for i=nStart:nEnd
    St=PeakFreq(i)*D/U
   % xaxis=i;
    scatter(nCases(i),St,'d','LineWidth',25);
    ylabel('St','FontSize',32,'interpreter','latex')
    xlabel('TestCases','FontSize',32,'interpreter','latex')
    %xticks([nCases])
    % xticklabels(lgd{:})
     grid on
    hold on
end
    set(gca,'Fontsize',32)
    title(['St - Strouhal Number'],'FontSize',32,'interpreter','latex')
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
         legend (lgd{:},'interpreter','latex','FontSize',32,'Location','southeast');
   % legend(legendCell,...
          % 'interpreter','latex','Location','SouthWest','Orientation','vertical','NumColumns',2,'fontsize',fontsize-4)
    legend('boxon')
   

 
 
    
