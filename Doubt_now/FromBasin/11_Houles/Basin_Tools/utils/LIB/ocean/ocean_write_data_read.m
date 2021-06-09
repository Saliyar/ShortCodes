function ocean_write_data_read(fid, file, ind, N_files)
%OCEAN_WRITE_DATA_READ write the ocean paragraph to read and build a wave
%from a data file
%   ocean_write_data_read(fid, file, n_harm, ind)
%   fid     ID of the opened .wav file 
%   file    name of the data file
%   ind     index of the wave in the .wav file (if several runs)
%   N_files optional, number of files
%
% See also ocean_write_header.m, ocean_write_run.m
%
if nargin < 3
    ind = 1;
end
%
if nargin < 4
    file_num = '';
    N_files  = 1;
else
    file_num = '_';
end
fprintf(fid, '/* Read and build poly-chromatic wave */\n');
fprintf(fid, 'wave the_wave%i = null;\n', ind);
for n=1:N_files
    if ~isempty(file_num)
        file_num = strcat('_', num2str(n));
    end
    fprintf(fid, 'wave the_wave%i%s = null;\n', ind, file_num);
    fprintf(fid, 'real data%i%s[] = [\n', ind, file_num);
    fprintf(fid, '#include "%s%s.dat"\n', file, file_num);
    fprintf(fid, '0];\n');
    fprintf(fid, 'for i=1 to (sizeof(data%i%s[])-1)/5 do\n', ind, file_num);
    fprintf(fid, '   harmo = floor(data%i%s[5*(i-1)+1]);\n', ind, file_num);
    fprintf(fid, '   ampli = data%i%s[5*(i-1)+3];\n', ind, file_num);
    fprintf(fid, '   angl = data%i%s[5*(i-1)+4];\n', ind, file_num);
    fprintf(fid, '   phas = data%i%s[5*(i-1)+5];\n', ind, file_num);
    fprintf(fid, '   the_wave%1$i%2$s = the_wave%1$i%2$s + front(harmo,ampli,angl,phas);\n', ind, file_num);
    fprintf(fid, 'end;\n');
    fprintf(fid, 'the_wave%1$i = the_wave%1$i + the_wave%1$i%2$s;\n', ind, file_num);
    fprintf(fid, '\n');
end
