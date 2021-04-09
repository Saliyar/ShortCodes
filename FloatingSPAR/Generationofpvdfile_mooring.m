%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code to generate the .pvd file format to read 
clc
close all
clear

%% INput for the file 
dt_MoorDynInput=0.01;
Time_MoorDynInput=10;
NumberOfTimesteps=Time_MoorDynInput/dt_MoorDynInput;
Moordyn_time_vector=0:dt_MoorDynInput:Time_MoorDynInput;

%% File location
ParaviewdataStoring=fullfile('/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/FreeDecay/HeaveFD/');
filename = [ParaviewdataStoring, filesep 'mooring' filesep 'Mooring.pvd'];
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
    fprintf(fid, ['file="' ParaviewdataStoring,'mooring' filesep 'mooring_' num2str(it) '.vtp"/>  \n']);
    
end
    
    

    fprintf(fid, '  </Collection>\n');
    fprintf(fid, '</VTKFile>');
    fclose(fid);