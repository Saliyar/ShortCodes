function ReadCoefficients(foamStarmovgenfile,nStart,nEnd)


for i=nStart:nEnd
     
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{20:end,1};
    foamStar_DragForce=data{20:end,3};
    idx=find(foamStar_dtForce1==30);
    
    plot(foamStar_dtForce1,foamStar_DragForce,'LineWidth',3);
    ylabel('Cd','FontSize',32)
    xlabel('Time [s]','FontSize',32)
    set(gca,'Fontsize',32)
    title(['Cd - Drag Coefficient '],'FontSize',32)
    % legend ('foamStar','SWENSE CoarseMesh','SWENSE SameMesh','Experiment','FontSize',32);
    grid on
    
    Cd=mean(foamStar_DragForce(idx:end))
    hold on
    
end
figure();
for i=nStart:nEnd
     
    FileName=[foamStarmovgenfile,num2str(i)]
    foamStarfullfile=fullfile(FileName,'postProcessing/forceCoeffs1/0/forceCoeffs1.dat');
    data=readtable(foamStarfullfile);
    
    foamStar_dtForce1=data{20:end,1};
    foamStar_LiftForce=data{20:end,4};
    plot(foamStar_dtForce1,foamStar_LiftForce,'LineWidth',3);
    hold on
    
end

