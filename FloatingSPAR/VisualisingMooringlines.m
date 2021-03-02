function VisualisingMooringlines(MooringPath,nStart_Line,nEnd_Line,NumberofSegments) 

n=0;
pp=0;

 for time=1:99
     
for j=nStart_Line:nEnd_Line
   n=n+1;
    SPAR_Postprocessing=[MooringPath,num2str(j) '.out' ];
    foamStarfullfile=fullfile(SPAR_Postprocessing)
    data=dlmread(foamStarfullfile); 
    clear pp;
    pp=0;
    length(data(:,1))
   
        
    for i=1:NumberofSegments+1
        Nodes(i,:)=[data(time,3*pp+2) data(time,3*pp+3) data(time,3*pp+4)];
        % plot3(Nodes(i,1),Nodes(i,2),Nodes(i,3),'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
        xyz = vertcat(Nodes(i,1),Nodes(i,2),Nodes(i,3));
        plot3(xyz(1,:),xyz(2,:),xyz(3,:),'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
        hold on
        pp=pp+1;
       
    end
    
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end
 pause(0.5)
 end

    
end
