function [eta, time, input] = read_SWEET_probes(directory)
% [eta, time, input] = read_SWEET_probes(directory, filename)
% LIB/SIMULATION/READ_SWEET_PROBES
% Reads the probes data contained in the SWEET probes data file implicitly 
% named 'probes.dat'
% Requires the number of probes : the function will open the file
% 'prob.inp' in the same directory
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
input = read_SWEET_input(directory, filename);
%
%% Data
fid = fopen([directory filename]);
% header
for i=1:80
    fgets(fid);
end;
% File title and variables list
fgets(fid); % TITLE=...
fgets(fid); % VARIABLES=...
%
probes   = load([directory 'prob.inp']);
n_probes = size(probes,1);
%
data = fscanf(fid,'%g');
data = reshape(data, 1+3*n_probes, length(data)/(1+3*n_probes)).';
time = data(:,1);
eta.first  = data(:,2:n_probes+1);
eta.second = data(:,n_probes+2:2*n_probes+1);
eta.total  = data(:,2*n_probes+2:3*n_probes+1);

%
%% End of file
fclose(fid);
