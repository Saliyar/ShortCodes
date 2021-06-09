function [eta, time, input, x, y, phis] = read_HOST_3d(directory)
% [eta, time, input, x, y, phis] = read_HOST_3d(directory, filename)
% LIB/SIMULATION/READ_HOST_3D
% Reads the free surface elevation data contained in the HOST
% 3d data file implicitly  named '3d.dat' stored in 'Results' directory
%
% Félicien 08/01/2010
%
%% Argument check
% making sure we have a '\' at the end of the directory name
if ~strcmp(directory(end),'\')
    directory = [directory '\'];
end
%
%% Input data
filename = '3d.dat';
input = read_HOST_input(directory, filename);
%
%% Data
fid = fopen([directory filename]);
% header
for i=1:87
    fgets(fid);
end;
% TITLE, VARIABLES
for i=1:2
    fgets(fid);
end
% First ZONE
line = fgets(fid);
time(1) = sscanf(line,'ZONE T = "t = %g s", I= 1, J=   1\n');
input.n1 = 1025
% First zone with spatial mesh
data = fscanf(fid,'%g',[4,input.n1*input.n2]).';
x    = data(1:input.n1,1);
y    = data(1:input.n1:input.n1*input.n2,2);
eta(1:input.n1,1:input.n2)  = reshape(data(:,3),[input.n1,input.n2]);
phis(1:input.n1,1:input.n2) = reshape(data(:,4),[input.n1,input.n2]);
fgets(fid); % end of line character
% Following zones without mesh
h_w = waitbar(0,'Reading file 3d.dat, please wait...');
n   = 1;
while 1
    line = fgets(fid); % ZONE
    if line == -1 % end of file
        disp('EOF')
        break
    end
    n = n + 1;
    time(n) = sscanf(line,'ZONE T = "t = %g s", I= 1, J=   1\n');
    data = fscanf(fid,'%g',[2,input.n1*input.n2]).';
    eta(1:input.n1,1:input.n2,n)  = reshape(data(:,1),[input.n1,input.n2]);
    phis(1:input.n1,1:input.n2,n) = reshape(data(:,2),[input.n1,input.n2]);
    fgets(fid); % end of line character
    waitbar(n/floor(input.T_stop*input.f_out/sqrt(input.h/9.81)))
end
close(h_w);
pause(0.01)
%
%% End of file
fclose(fid);
