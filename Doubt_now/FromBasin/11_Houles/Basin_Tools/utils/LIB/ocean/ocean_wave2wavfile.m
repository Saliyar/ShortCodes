function ocean_wave2wavfile(wv, file, title, routine, runs, ttf)
%OCEAN_WAVE2WAVFILE write the wave data into an ocean's .wav file
%   ocean_wave2wavfile(wv, file, title, routine, runs)
%   wv      wave objects
%   file    .wav base file name
%   title   experiment title, will appear in the wavemaker GUI
%   routine name of the routine used to generate the .wav file (for
%           reference in the .wav files)
%   runs    runs titles
%   ttf     full name of the .ttf file. The default is 'nantes_main_posn/default.ttf'
%           other possilities are 'nantes_main_force\defaults.ttf, ...
%                                 'nantes_towing\bassin1.ttf', ...
%                                 'nantes_twin\....)
%
% See also ocean_write_header.m, ocean_write_data_read.m, ocean_write_run.m
%
if nargin < 6
    ttf = 'nantes_main_posn/default.ttf';
end
if size(runs,1) ~= length(wv)
    error('Mismatch between number of waves and number of runs titles')
end
rnum = calc_rnum(get(wv,'T_repeat'));
%
[path, file, ext] = fileparts(file);
file = [file, ext];
if ~exist(path)
    mkdir(path);
end
if ~exist(fullfile(path,'data'))
    mkdir(path, 'data');
end

% ocean 30 runs rules
N_30 = floor(length(wv)/30)+1;
for m=1:N_30
    if N_30 == 1
        base = fullfile(path,file);
        add_title = '';
    else
        base = fullfile(path,strcat(file, '_part ', num2str(m)));
        add_title = sprintf(', part %i over %i', m, N_30);
    end
    full_title = strcat(title, add_title);
    fid_sum = ocean_write_summary_header(base, full_title, routine, ttf);
    fid     = ocean_write_header(base, full_title, routine, ttf);
    for n=((m-1)*30+1):min(length(wv),m*30)
        % .dat file
        file_n = fullfile('data',strcat(file, '_', num2str(n)));
        % ocean 2000 components rules
        ocean_write_summary_data(fid_sum, n, wv(n))
        N_2000 = export(wv(n), 'ocean', fullfile(path,file_n));
        % data text
        ocean_write_data_read(fid, file_n, n, N_2000)
    end
    fprintf(fid,'/* End of wave data */\n');
    fprintf(fid,'\n');
    fprintf(fid,'begin\n');
    for n=((m-1)*30+1):min(length(wv),m*30)
        ocean_write_run(fid, strtrim(runs(n,:)), rnum, n)
    end
    fprintf(fid,'end;\n');
    fclose(fid);
    fclose(fid_sum);
end
