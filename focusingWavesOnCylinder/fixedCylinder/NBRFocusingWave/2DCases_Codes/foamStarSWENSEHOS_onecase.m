function foamStarSWENSEHOS_onecase(HOSpath,HOSIndices,foamStarfile,SWENSEfile)

%% Loading data HOS, foamStar and SWENSE 
data_HOS=readtable(HOSpath);
dt_HOS=data_HOS{:,1};
dt_HOS1=dt_HOS-dt_HOS(1);
Eta_HOS=data_HOS{:,2:end};


foamStarfullfile=fullfile(foamStarfile,'waveProbe/0/surfaceElevation.dat')
data1=readtable(foamStarfullfile);
dt_foamStar=data1{:,1};
Eta_foamStar=data1{:,2:end};

if(any(dt_foamStar==37))
	foamStarIndices=find(dt_foamStar==37):find(dt_foamStar==42);
else
	foamStarIndices=find(dt_foamStar==0):find(dt_foamStar==5);
end



SWENSEfullfile=fullfile(SWENSEfile,'waveProbe/0/surfaceElevation.dat')
data2=readtable(SWENSEfullfile);
dt_SWENSE=data2{:,1};
Eta_SWENSE=data2{:,2:end};

if(any(dt_SWENSE==37))
	SWENSEIndices=find(dt_SWENSE==37):find(dt_SWENSE==42);
else
	SWENSEIndices=find(dt_SWENSE==0):find(dt_SWENSE==5);
end


%% Index for HOSplot(dt_foamStar,Y_axis1,'LineWidth',2)
for i=1:3

	probe_CFD=i;	
	probe_HOS=i+4;
	

	%% HOS file processing
	
	Y_axis1=interp1(dt_foamStar,Eta_foamStar(foamStarIndices,probe_CFD),dt_SWENSE,'spline');
	Y_axis2=interp1(dt_SWENSE,Eta_SWENSE(SWENSEIndices,probe_CFD),dt_SWENSE,'spline');
	Y_axis_HOS=interp1(dt_HOS1,Eta_HOS(HOSIndices,probe_HOS),dt_SWENSE,'spline');

	Y_axis=[Y_axis1 Y_axis2 Y_axis_HOS];

	figure()

	for j=1:3
	    plot(dt_SWENSE,Y_axis(:,j),'LineWidth',2)
            hold on;
	    xlim([0.05 5])
	    ylabel('surface elevation [m]','FontSize',32)
	    xlabel('Time [s]','FontSize',32)
	    set(gca,'Fontsize',32)
	    title(['WP ',num2str(j+4)],'FontSize',32)
	    legend ('foamStar','Experiment','FontSize',32);
	    grid on;
	end
	legend ('foamStar','SWENSE','HOS','FontSize',32);
	hold off;
end
