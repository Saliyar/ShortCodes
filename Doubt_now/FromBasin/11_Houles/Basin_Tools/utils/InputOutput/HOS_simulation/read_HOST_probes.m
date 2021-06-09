function [eta, time, input] = read_HOST_probes(directory, filename)
% [eta, time, input] = read_HOST_probes(directory, filename)
% LIB/SIMULATION/READ_HOST_PROBES
% Reads the probes free surface elevation data contained in the HOST
% probes data file implicitly  named 'probes.dat' stored in 'Results' directory
%
% Félicien 23/09/2010
%
%% Input data
filename = 'probes.dat';
% input = read_HOST_input(directory, filename);
input = [];
%
%% Data
fid = fopen(fullfile(directory, filename));
% header
for i=1:59
    fgets(fid);
end;
% TITLE, VARIABLES
for i=1:2
    line = fgets(fid);
end
% Number of probes = number of variables - 1 (time column)
n_probes = length(strfind(line, '"')) / 2 - 1;
% Probes data
data = fscanf(fid,'%g', Inf);
% Number of time steps
n_time = length(data) / (n_probes + 1);
% Reshaping the variables
data = reshape(data, [n_probes+1, n_time]).';
time = data(1:n_time,1);
eta  = data(1:n_time,2:end);
%
%% End of file
fclose(fid);
