function [wmk, rnum] = import(wmk, file_name)
% @WAVEMAKER/IMPORT import the wavemaker properties from the specified
% object in a file
%
if nargin < 2 || strcmp(file_name,'')
    file_name = 'export';
end
% Reading a config file
fid      = fopen([file_name '.cfg'],'r');
rnum     = fscanf(fid,'%d\n',1);
line     = fgets(fid); % clock = 32
depth    = fscanf(fid,'%f\n',1);
ramp     = fscanf(fid,'%f\n',1);
typ_ramp = fscanf(fid,'%s\n',1);
line     = fgets(fid); % cutoff_low  = 0
line     = fgets(fid); % cutoff_high = 4
Ly       = fscanf(fid,'%f\n',1);
type     = fscanf(fid,'%s\n',1);
hinge_bottom = fscanf(fid,'%f\n',1);
fclose(fid);
% Building the object
wmk = wavemaker(depth,type,hinge_bottom,0,1,Ly,typ_ramp,ramp);
