function Ncases_foamStarSWENSEExpt_pressure(Exptpressurepath,ExptPressureIndices,BaseName_foamStar,BaseName_SWENSE,cps,PP_static,numfoamStar,nSWENSE,nstart,nend,lgd)


%% Code to check the Pressure probe results between foamStar and SWENSE
%% Experimental results loading

load(Exptpressurepath)

PP_Expt=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];

%Selection time 5s to 35s overall. with constant phase shift is reduced

pl_time=pp2(:,1);   %Added for checking full time series of experiment
pl_timeA=pp2(ExptPressureIndices,1)
pl_timeB=pl_timeA-pl_timeA(1)-cps; %

%% foamStar Cases loading
for k=1:numfoamStar
    FileName=[BaseName_foamStar,num2str(k)]
    foamStarfullfile=fullfile(FileName,'postProcessing/probes/0/p')
    data=readtable(foamStarfullfile);
    
    %Finding Indexes
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    foamStar_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_foamStar=data{start_idx:end_idx,2:end};
            for pp=2:8
                foamStar_PP(:,pp,k) = PP_foamStar(start_idx:end_idx,pp)*0.01-PP_static(pp);
                
            end
end

%% SWENSE Cases loading

for k=1:nSWENSE
    FileName=[BaseName_SWENSE,num2str(k)]
    SWENSEfullfile=fullfile(FileName,'postProcessing/probes/0/p')
    data=readtable(SWENSEfullfile);
    
    start_idx=find(data{:,1}==nstart)
    end_idx=find(data{:,1}==nend)
    
    
    SWENSE_dtPP(:,k)=data{start_idx:end_idx,1};
    PP_SWENSE=data{start_idx:end_idx,2:end};
    
        for pp=2:8
            SWENSE_PP(:,pp,k) = PP_SWENSE(start_idx:end_idx,pp)*0.01-PP_static(pp);
        end
end


for i=2:8
    FigH = figure('Position', get(0, 'Screensize'));
    
        Expt_yaxis=PP_Expt(ExptPressureIndices,i);
        plot(pl_timeB,Expt_yaxis,'LineWidth',3)
        hold on
 %% FoamStar cases loading  ...    
 
 for k=1:numfoamStar
     plot(foamStar_dtPP(:,k),foamStar_PP(:,i,k),'LineWidth',3);     
    hold on 
 end
 hold on
  for k=1:nSWENSE
     plot(SWENSE_dtPP(:,k),SWENSE_PP(:,i,k),'LineWidth',3);     
    hold on 
  end
    
    xlim([0.05 2.5])
    ylabel('Dynamic Pressure [mBar]','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['PP ',num2str(i)],'FontSize',32)
    % legend ('Experiment','foamStar1','foamStar2','SWENSE1','SWENSE2','FontSize',32);
   legend (lgd{:},'interpreter','latex','FontSize',32,'Location','northwest','NumColumns',2);
    grid on;
    hold off
    saveas(FigH, ['PP ',num2str(i)],'png');
end

 
