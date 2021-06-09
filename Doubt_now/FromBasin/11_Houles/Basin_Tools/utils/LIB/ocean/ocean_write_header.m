function fid = ocean_write_header(file, title, routine, ttf)
%OCEAN_WRITE_HEADER open and write the ocean header
%   ocean_write_header(file, title, routine, ttf)
%   fid = ocean_write_header(file, title, routine, ttf)
% Inputs
%   file    name of the data file
%   title   title of the experiment in ocean file (will show on the
%           wavemaker GUI (max. length is 80 characters)
%   routine name of the MATLAB routine used to create the .wav file
%   ttf     full name of the .ttf file (default: 'nantes_main_posn/default.ttf' ;
%           other possilities are 'nantes_main_force\defaults.ttf, ...
%                                 'nantes_towing\bassin1.ttf', ...
%                                 'nantes_twin\....)
%   Outputs
%   fid     ID of the opened .wav file 
%
% See also ocean_write_data_read.m, ocean_write_run.m, ocean_wave2wavfile.m
%
if nargin < 2
    error('Title showing up in GUI should be given')
end
if length(title) > 80
    warning('Experiment title will be cut after the 80th character in ocean_write_header')
end
if nargin < 3
    routine = '...';
end
if nargin < 4
    ttf = 'nantes_main_posn/default.ttf';
end
fid  = fopen(strcat(file,'.wav'), 'w');
fprintf(fid,'experiment "%s" with ("%s")\n', title, ttf);
fprintf(fid,'\n');
fprintf(fid,'int i;\n');
fprintf(fid,'int harmo;\n');
fprintf(fid,'real ampli;\n');
fprintf(fid,'real angl;\n');
fprintf(fid,'real phas;\n');
fprintf(fid,'\n');
fprintf(fid,'/* Wave data read from .dat files prepared with MatLab routine %s.m */\n', routine);
fprintf(fid,'\n');
