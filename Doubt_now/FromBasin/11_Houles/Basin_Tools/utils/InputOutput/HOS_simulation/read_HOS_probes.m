function [eta, time, input] = read_HOS_probes(directory)
% [eta, time, input] = read_HOS_probes(directory, filename)
% LIB/SIMULATION/READ_HOS_PROBES
% Reads the probes data contained in the HOS probes data file implicitly 
% named 'probes.dat' stored in 'Results' directory
% Requires the number of probes : the function will open the file
% 'prob.inp' in the parent directory
%
% Félicien 10/09/2009
%
%% Argument check
% making sure we have a '\' at the end of the directory name
if ~strcmp(directory(end),'\')
    directory = [directory '\'];
end
%
%% Input data
filename = 'probes.dat';
input = read_HOS_input(directory, filename);
%
%% Data
fid = fopen([directory filename]);
% header
for i=1:87
    fgets(fid);
end;
% File title and variables list
fgets(fid); % TITLE=...
fgets(fid); % VARIABLES=...
%
probes   = load([directory '\..\prob.inp']);
n_probes = size(probes,1);
%
data = fscanf(fid,'%g');
data = reshape(data, 1+n_probes, length(data)/(1+n_probes)).';
time = data(:,1);
eta  = data(:,2:n_probes+1);

%
%% End of file
fclose(fid);
