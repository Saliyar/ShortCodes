%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code to Generate the Wave probe.txt for foamStar
%% Input for the Files
Dimension='A';  %Dimension A for 2D, B for 3D
switch Dimension
    case 'A'
        clear;
%% Major Inputs below:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        negative_z=-0.25;            % The Probe negative z axis location for start of the block
        postive_z=0.25;              % The positive z axis location for end of the block
        y_axis=0;                % The y axis location where the grid is developed
        x_axis_starting=-17;  % The Probe - X axis starting location 
        x_axis_end=17;% Assuming the grid is oriented at centre
        delta_x= 0.01;             % Mesh spacing in x direction
        
 %% Diagonal Probes Placing
%         theta=45;
%         radius=0.14;
%         y_diag_start=radius*sind(theta); 
%         x_diag_start=radius*cosd(theta) %negative sign for -x direction
%         x_diag_end=x_axis_end;
%         y_diag_end=x_axis_end;
%         
%         x_diag=x_diag_start;
%         y_diag=y_diag_start;
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        x=x_axis_starting;
        
        
        iter=1;
        n=100;
        deltaX=0;
        while x<=x_axis_end
            iter=iter+1;
            x=x+delta_x;
        end   
        N=zeros(length(iter),1);
        X=zeros(length(iter),1);
        Xdiag=zeros(length(iter),1);
        Ydiag=zeros(length(iter),1);
        for i=1:iter
            N(i,1)=n+i;
            X(i,1)=x_axis_starting+deltaX;
            deltaX=i*delta_x;
            Y(i,1)=y_axis;
            negative_Z(i,1)=negative_z;
            positive_Z(i,1)=postive_z;
        end
        
    % For diagonal terms 
%         deltaX=0;
%        for i=1:iter
%            N(iter+i,1)=(iter+n)+i;
%            X(iter+i,1)=x_diag+deltaX;
%            Y(iter+i,1)=y_diag+deltaX;
%            negative_Z(iter+i,1)=negative_z;
%            positive_Z(iter+i,1)=postive_z;
%            deltaX=i*delta_x;    
%            
%        end
        
        
         Final_Matrix=[N X Y negative_Z X Y positive_Z];
    otherwise
        disp('Enter either A or B');
end   
fileID=fopen('Waveprobes.txt','w');
fprintf(fileID,'#inputMode overwrite;\n \n');
fprintf(fileID,'functions\n{\n   waveProbe\n   {\n      type surfaceElevation;\n');
fprintf(fileID,'      outputControl timeStep;\n      outputInterval  1;\n');
fprintf(fileID,'      defaultParams { type face; axis z; nPoints  100;}\n');
fprintf(fileID,'      sets\n      (\n');
%formatSpec1='   arc %d %d (%6.4f %6.4f %6.4f) \n'; %Format for Blocks
%fprintf(fileID,formatSpec1,Edges4.');
formatSpec='         p0%d  {start ( %8.6f %8.6f %8.6f); end ( %8.6f %8.6f %8.6f); $defaultParams}\n';
fprintf(fileID,formatSpec,Final_Matrix.');
fprintf(fileID,'      );\n    }\n}');
%% Close the file
fclose(fileID);