function C11_wave2wmk_ocean(file, titles, wave, wave_basin, runs)
% build a .wav file containing several runs in the same basin
% file           .wav filestructure containing
%   file.name    name of the .wav file
%   file.header  experiment title that will appear in the client.exe windows
%   file.path    
% titles         one run title per wave element
% wave           cell array of wave object, one per run
% wave_basin     among 'ECN_wave', 'ECN_towing' and 'ECN_small'

if nargin < 5
    runs = 1:length(wave);
end
addpath('./classes')
addpath('./lib/potential_theory')
%
%% Wavemaker parameters
check_wavemaker_motion_speed = 0;
export_2_HOS = 1;
%
N_runs = length(wave);
%% Wavemaker parameters
% Wavemaker correction
multiplier_linear = ones(1,N_runs); % linear wavemaker transfer function correction (gain)
multiplier_nonlinear = ones(1, N_runs); % nonlinear wavemaker transfer function  (induced by steepness)
% output preparation
ocean_prepare_folder(file.path);
% obtain caller function
ST = dbstack(1);
routine = [ST.file(1:end-2), '\', mfilename];
%
switch wave_basin
    case 'ECN_wave'
        ttf_file = 'nantes_main_posn/default.ttf';
    case 'ECN_towing'
        ttf_file = 'nantes_towing/towing_h2p9_v3.ttf';
    case 'ECN_small'
        ttf_file = 'nantes_twin/Twin_h094.ttf';
end
fid = ocean_write_header([file.path, '/', file.name], file.header, routine, ttf_file);
fid_sum = ocean_write_summary_header([file.path, '/', file.name], file.header, routine, ttf_file);
%
for run = runs
    % wavemaker
    c_law = get(wave{run}, 'control_law');
    rnum(run) = log2(get(wave{run}, 'T_repeat'))+5;
    file_name_suffix = ['_run_', num2str(run, '%02d')];
    if check_wavemaker_motion_speed
        % check the wavemaker motion
        LHEEA_check_wavemaker(wave{run}, 20+run)
    end
    % correcting transfer function = nonlinear effects
    % before exporting to HOS
    wave{run} = multiplier_nonlinear(run) * wave{run};
    if export_2_HOS
        % export for HOS
        export(wave{run}, 'cfgdat', fullfile(file.path, 'data', strcat(file.name, '_HOS', file_name_suffix)));
    end
    % correcting transfer function (gain) = wrong transfer function
    % specific to experimental wavemaker so after exporting to HOS
    wave{run} = multiplier_linear(run) * wave{run};
    % exporting to files
    file_run = fullfile('data', strcat(file.name, file_name_suffix));
    % ocean 2000 components per file rule
    ocean_write_summary_data(fid_sum, run, wave{run})
    N_2000 = export(wave{run}, 'ocean', fullfile(file.path, file_run));
    % data text
    ocean_write_data_read(fid, file_run, run, N_2000)
end
%%
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
%% writing runs
for m=runs
    ocean_write_run(fid, titles{m}, rnum(m), m)
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

% warning('off', 'MATLAB:rmpath:DirNotFound')
% rmpath(path_lib)

