function foamStarMovDiffCases(Exptforcepath,ExptIndices,foamStarmovgenfile,nStart,nEnd,cps,Exptpressurepath,PP_static)

[Expt_time_corrected,Expt_yaxis]=Expt_force(Exptforcepath,ExptIndices);



for i=nStart:nEnd
     
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'/postProcessing/forces/0/forces1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{2:end,1}+cps;
    foamStar_TotalForce1=data{2:end,2}+data{2:end,5};
    
    plot(foamStar_dtForce1,foamStar_TotalForce1,'LineWidth',3);
    hold on

    
end
plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);
    % plot(SWENSE_dtForce,SWENSE_TotalForce,'LineWidth',3);
    ylabel('Force(N)','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    xlim([0.5 14.5])
    set(gca,'Fontsize',32)
    title('Totalforce X' ,'FontSize',32)
    legend ('Euler-Laminar','CN-Laminar','Euler-fskepsilon','CN-fskepsilon','MediumMesh-Euler-Laminar','MediumMesh-CN-Laminar','FineMesh-Euler-Laminar','FineMesh-CN 095 - Laminar','Experiment','FontSize',32);
    grid on;

 disp('Press a key !')  % Press a key here.You can see the message 'Paused: Press any key' in        % the lower left corner of MATLAB window.
pause;   
    %%%% Plotting Pressure from Experiment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    movfoamStarExpt_pressure(Exptpressurepath,ExptIndices,foamStarmovgenfile,cps,PP_static,nStart,nEnd)