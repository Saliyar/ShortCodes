
clc
close all
clear

%% MoorDyn parameters 
numLines=9;
nline=numLines;
model='Catenary Mooring SPAR case';
simdate=date;
dt_MoorDynInput=0.01;
Time_MoorDynInput=3.7;
NumberOfTimesteps=Time_MoorDynInput/dt_MoorDynInput;
Moordyn_time_vector=0:dt_MoorDynInput:Time_MoorDynInput;
dtParaview=dt_MoorDynInput;
ParaviewdataStoring=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/MoorDynCoupling/SPAR_Hydrostatics_R3');

%% Generating number of nodes and number of segments 
 % load Lines.out
            filename = '/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/MoorDynCoupling/SPAR_Hydrostatics_R3/Mooring/Lines.out';
            fid = fopen(filename, 'r');
            header = strsplit(fgetl(fid));
            data = dlmread(filename,'',3,0);
            tmp = size(data);
            ncol = tmp(2);clear tmp
            for icol=1:ncol
               eval(['obj.moorDyn.Lines.' header{icol} ' = data(:,' num2str(icol) ');']);
            end
            fclose(fid);
            % load Line#.out
            for iline=1:numLines
                eval(['obj.moorDyn.Line' num2str(iline) '=struct();']);
                filename = ['/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/MoorDynCoupling/SPAR_Hydrostatics_R3/Mooring/Line' num2str(iline) '.out'];
                try
                    fid = fopen(filename);
                    header = strsplit(strtrim(fgetl(fid)));
                    data = dlmread(filename,'',2,0);
                    tmp = size(data);
                    ncol = tmp(2);clear tmp
                    for icol=1:ncol
                        eval(['obj.moorDyn.Line' num2str(iline) '.' header{icol} ' = data(:,' num2str(icol) ');']);
                    end
                    fclose(fid);
                catch
                    fprintf('\n No moorDyn *.out file saved for Line%u\n',iline); 
                end
            end
            
            
%% Generating nnodes and nsegments from obj struct

fn=fieldnames(obj.moorDyn);

for k=2:numel(fn)  % From 2 because we are reading only nodes and segments file from org
    Fields=obj.moorDyn.(fn{k});
    Linefieldnames=fieldnames(Fields);
    OverallLength=length(Linefieldnames)-1;
    nnode(k-1)=(OverallLength+1)/4;
    nsegment(k-1)=nnode(k-1)-1;    
end
 
%% Writing in vtp format
for it = 1:length(Moordyn_time_vector)
    current_time=Moordyn_time_vector(it)
    % open file
   % filename = [ParaviewdataStoring, filesep 'mooring' filesep 'mooring_.' sprintf('%4.2f',current_time)  '.vtp'];
     filename = [ParaviewdataStoring, filesep 'Mooring' filesep 'mooring_' num2str(it)  '.vtp']

    fid = fopen(filename, 'w');
    % write header
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, ['<!-- foamStar Visualization using ParaView -->\n']);
    fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
    fprintf(fid, ['<!--   mooring:  MoorDyn -->\n']);
    fprintf(fid, ['<!--   time:  ' num2str(Moordyn_time_vector(it)) ' -->\n']);
    fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
    fprintf(fid, '  <PolyData>\n');
    % write line info
    for iline = 1:nline
        fprintf(fid,['    <Piece NumberOfPoints="' num2str(nnode(iline)) '" NumberOfLines="' num2str(nsegment(iline)) '">\n']);
        % write points
        fprintf(fid,'      <Points>\n');
        fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
        for inode = 0:nnode(iline)-1
            pt = [obj.moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'px'])(it), obj.moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'py'])(it),obj.moorDyn.(['Line' num2str(iline)]).(['Node' num2str(inode) 'pz'])(it)];
            fprintf(fid, '          %5.5f %5.5f %5.5f\n', pt);
        end; clear pt inode
        fprintf(fid,'        </DataArray>\n');
        fprintf(fid,'      </Points>\n');
        % write lines connectivity
        fprintf(fid,'      <Lines>\n');
        fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
        count = 0;
        for isegment = 1:nsegment(iline)
            fprintf(fid, ['          ' num2str(count) ' ' num2str(count+1) '\n']);
            count = count +1;        
        end; clear count isegment
        fprintf(fid,'        </DataArray>\n');
        fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
        fprintf(fid, '         ');
        for isegment = 1:nsegment(iline)
            n = 2*isegment;
            fprintf(fid, ' %i', n);
        end; clear n isegment
        fprintf(fid, '\n');
        fprintf(fid,'        </DataArray>\n');
        fprintf(fid, '      </Lines>\n');
        % write cell data
        fprintf(fid,'      <CellData>\n');
        % Segment Tension
        fprintf(fid,'        <DataArray type="Float32" Name="Segment Tension" NumberOfComponents="1" format="ascii">\n');
        for isegment = 0:nsegment(iline)-1
            fprintf(fid, '          %i', obj.moorDyn.(['Line' num2str(iline)]).(['Seg' num2str(isegment) 'Te'])(it));
        end 
        fprintf(fid, '\n');
        fprintf(fid,'        </DataArray>\n');
        fprintf(fid,'      </CellData>\n');
        % end file
        fprintf(fid, '    </Piece>\n');        
    end
    % close file
    fprintf(fid, '  </PolyData>\n');
    fprintf(fid, '</VTKFile>');
    fclose(fid);
end 

%% To create a pvd file to view the Mooring lines as matching with timestep!! 

filename = [ParaviewdataStoring, filesep 'Mooring' filesep 'Mooring.pvd'];
fid = fopen(filename, 'w');
% write header
    fprintf(fid, '<?xml version="1.0"?>\n');
    fprintf(fid, ' <VTKFile type="Collection" version="0.1" \n');
    fprintf(fid, ' byte_order="LittleEndian" \n');
    fprintf(fid, ' compressor="vtkZLibDataCompressor"> \n');
    fprintf(fid, '  <Collection>\n');
% Bunching the Timestep together
for it = 1:length(Moordyn_time_vector)
    current_time=Moordyn_time_vector(it);
    
    fprintf(fid, ['<DataSet timestep="' num2str(current_time) '" group="" part="0" \n']);
    fprintf(fid, ['file="' ParaviewdataStoring, filesep 'Mooring' filesep 'mooring_' num2str(it) '.vtp"/>  \n']);
    
end   
    fprintf(fid, '  </Collection>\n');
    fprintf(fid, '</VTKFile>');
    fclose(fid);

clear it iline nline nnode nsegment model t