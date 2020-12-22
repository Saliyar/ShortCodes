function foamStarExpt_compAll(Exptforcepath,ExptIndices,foamStarfile1,foamStarfile2,cps);

%% Code to compare the force results between foamStar and SWENSE

[Expt_time_corrected,Expt_yaxis]=Expt_force(Exptforcepath,ExptIndices);


%% foamStar NBR focusing fixed cylinder force results loading First results 

foamStarfullfile=fullfile(foamStarfile1,'forces/0/forces1.dat')
data=readtable(foamStarfullfile);

%% In the datafile - first col is time 
%% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
%% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)

foamStar_dtForce1=data{2:end,1}+cps; % Added the constant phase shift 

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForce1=data{2:end,2}+data{2:end,5};
%% foamStar NBR focusing fixed cylinder force results loading First results 

foamStarfullfile=fullfile(foamStarfile2,'forces/0/forces1.dat')
data=readtable(foamStarfullfile);
foamStar_dtForce2=data{2:end,1}+cps; % Added the constant phase shift 

%Adding Pressure x component and Viscous x componenet
%Also ignoring the first term spike

foamStar_TotalForce2=data{2:end,2}+data{2:end,5};

% %% SWENSE NBR focusing fixed cylinder force results loading
% SWENSEfullfile=fullfile(SWENSEfile,'forces/0/forces1.dat')
% data=readtable(SWENSEfullfile);
% 
% %% In the datafile - first col is time 
% %% 2 to 10 col - forces (Pressure componenets, viscous and porosity)
% %% 11 to 20 col - Moements due to(Pressure force, Viscous and porosity)
% 
% SWENSE_dtForce=data{2:end,1}+cps; % Added the constant phase shift given ISOPE team
% 
% %Adding Pressure x component and Viscous x componenet
% %Also ignoring the first term spike
% 
% SWENSE_TotalForce=2*data{2:end,2}+data{2:end,5};
% 


figure()
plot(foamStar_dtForce1,foamStar_TotalForce1,'LineWidth',3);
hold on
plot(foamStar_dtForce2,foamStar_TotalForce2,'LineWidth',3);
hold on
plot(Expt_time_corrected,Expt_yaxis,'LineWidth',3);
hold on
% plot(SWENSE_dtForce,SWENSE_TotalForce,'LineWidth',3);
ylabel('Force(N)','FontSize',32)
xlabel('Time [s]','FontSize',32)
xlim([0.5 14.5])
set(gca,'Fontsize',32)
title('Totalforce X' ,'FontSize',32)
legend ('foamStar - Euler','foamStar - CN 0.95','Experiment','FontSize',32);
grid on;
