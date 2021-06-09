function ocean_write_summary_irregular(fid, ind, H_s, T_p, direction, spreading, phase)
% OCEAN_WRITE_SUMMARY_IRREGULAR write the wave information into .txt file
%   ocean_write_summary_irregular(fid, ind, H_s, T_p, direction, spreading, phase)
%   fid = ocean_write_summary_irregular(fid, ind, H_s, T_p, direction, spreading, phase)
% Inputs
%   fid         ID of the opened .wav file
%   ind         index of the run
%   H_s         significant wave height
%   T_p         peak period
%   direction   mean wave direction
%   spreading   directional spreading 
%   phase       set of random phase
%
% See also ocean_write_summary_header.m, ocean_write_summary_data.m, ocean_write_header.m 
%
fprintf(fid, '/* Irregular wave data*/\n');
fprintf(fid, 'wave (or run) %i;\n', ind);
fprintf(fid, 'Peak Period\tPeak Frequency\tSig. Wave Height\tDirection\tspreading\tPhase\n');
fprintf(fid, 's\tHz\tm\tdeg\tdeg\tnumber\n');
fprintf(fid, '%g\t%g\t%g\t%g\t%g\t%g\n',[T_p, 1/T_p, H_s, direction, spreading, phase]);


