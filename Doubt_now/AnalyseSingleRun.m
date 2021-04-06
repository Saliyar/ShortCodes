function Err = AnalyseSingleRun(path_num,num_case,time_Sriram,PP_Sriram,info)
    switch num_case
        case 'Co_0.1'
            %%% Give bornes for correspondance num/exp
            tbeg = 37;
            tend = 40;
            
        case 'Co_0.15'
            %%% Give bornes for correspondance num/exp
            tbeg = 37;
            tend = 42;
            
        case 'Co_0.2'
            %%% Give bornes for correspondance num/exp
            tbeg = 5;
            tend = 43;
            
    end
    

    
    % Compute part of the experiment that corresponds to the numerical run
    indices = find((time_Sriram>=tbeg) .* (time_Sriram<tend));
    
    time_Sriram_B=time_Sriram(indices)-time_Sriram(indices(1));
    time_Sriram_B_full = time_Sriram -time_Sriram(indices(1));% Zero is numerical zero time
    
    
    % Load Num
    [time_num, PP_num_mbar] = loadNumDataFoamStar(path_num,num_case);
    
    % Interp Exp on Num
    ExpInterp= interp1(time_Sriram_B_full,PP_Sriram(:,:),time_num,'spline');
    
    %%% Interval where error will be computed
    tbeg_err_num =info.tbeg_err-tbeg;
    tend_err_num = info.tend_err -tbeg;
    IIError = find((time_num>tbeg_err_num) .* (time_num<tend_err_num));
    
    for iProbe=2:8
        label = [strrep(num_case,'_',' ') ' Pressure Probe' num2str(iProbe)];
        %%% interp
        
        figure(3)
        hold off;
        plot(time_num,PP_num_mbar(:,iProbe))
        hold on;
        plot(time_Sriram_B,PP_Sriram(indices,iProbe))
        plot(time_num, PP_num_mbar(:,iProbe)-ExpInterp(:,iProbe))
        
        
        %% RMSE between each graph
        
      
        Err(iProbe) = computeErrors(time_num(IIError),PP_num_mbar(IIError,iProbe),ExpInterp(IIError,iProbe),label);
        
        %     figure()
        %     hold off;
        %     plot(time_num,PP_num_mbar(:,iProbe),'LineWidth',4)
        %     hold on;
        %     plot(time_num,ExpInterp(:,iProbe),'LineWidth',4)
        %     % plot(pl_timeB,Expt_yaxis,'LineWidth',4)
        %     ylabel('Dynamic Pressure [mBar]','FontSize',32)
        %     xlabel('Time [s]','FontSize',32)
        %     set(gca,'Fontsize',32)
        %     title(['PP ',num2str(iProbe)],'FontSize',32)
        %     legend ('foamStar','Experiment','FontSize',32);
        %     grid on;
    end