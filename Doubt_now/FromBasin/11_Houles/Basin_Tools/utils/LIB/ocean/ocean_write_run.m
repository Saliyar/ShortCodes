function ocean_write_run(fid, text, rnum, ind)
%OCEAN_WRITE_RUN write the ocean's run
%   ocean_write_run(fid, text, ind, rnum)
%   fid     ID of the opened .wav file 
%   text    title of the run (will appear in the wavemaker GUI, max. length 80 characters)
%   rnum    rnumber
%   ind     index of the wave in the .wav file (if several runs)
%
% See also ocean_write_header.m, ocean_write_data_read.m
%
if nargin < 4
    ind = 1;
end
%
fprintf(fid, '   run "%s" with (%i)\n', text, rnum);
fprintf(fid, '      makewave the_wave%i on 1;\n', ind);
fprintf(fid, '   end;\n');

