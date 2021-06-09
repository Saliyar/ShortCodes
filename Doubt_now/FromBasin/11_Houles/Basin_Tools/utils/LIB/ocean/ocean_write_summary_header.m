function fid = ocean_write_summary_header(file, title, routine, ttf)
% OCEAN_WRITE_SUMMARY_HEADER write the wave information header into .txt file
%   ocean_write_summary_header(file, title, routine, ttf)
%   fid = ocean_write_summary_header(file, title, routine, ttf)
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
% See also ocean_write_header.m, ocean_write_run.m
%
fid  = fopen(strcat(file,'_summary.txt'), 'w');
fprintf(fid,'experiment "%s" with ("%s")\n', title, ttf);
fprintf(fid,'/* Wave data read from .dat files prepared with MatLab routine %s.m */\n', routine);
