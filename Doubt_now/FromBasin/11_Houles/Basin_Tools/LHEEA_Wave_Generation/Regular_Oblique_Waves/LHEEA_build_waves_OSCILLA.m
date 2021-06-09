function LHEEA_build_waves_OSCILLA
rmpath('C:\Program Files\MATLAB\R2016a\toolbox\symbolic\symbolic'); % Use in case of prob with harmonic
rmpath('C:\Program Files\MATLAB\R2018b\toolbox\symbolic\symbolic');

%
addpath ../classes
addpath(genpath('../lib'))
warning('off', 'convert2nondim:allready')
warning('off', 'FeBo:make_it_column')

%
series = 1; %1= initial file
remove_free_waves = 0;
%
[periods, amplis, correc, rnum, name] = LHEEA_define_waves_OSCILLA(series);
%
T_repeat = calc_T_repeat(rnum);
%
harmo_target = floor(T_repeat ./ periods);
%
wmk  = wavemaker('ECN_wave');
%
Project_name = 'MARINET2_Mocean';
path = prepare_ocean_folder(fullfile(Project_name,'\', name));
%
% Experiment title, will appear in wavemaker GUI
title = strcat('Regular waves for MARINET2/ECN-LHEEA/OSCILLA campaign');
routine = mfilename; % for reference in the .wav files
%
fid = ocean_write_header(fullfile(path, name), title, routine);
fid_sum = ocean_write_summary_header(fullfile(path, name), title, routine, 'nantes_main_posn/default.ttf');
%
runs = 1:length(periods);
%
for n=runs
    harmo = harmonic(harmo_target(n),amplis(n));
    wv_1st = wave(T_repeat, 16, harmo, wmk);
    if remove_free_waves
        %% Correction
        wv_free = eval_free_waves(wv_1st, 400, 'hinged');
        a_free(n)  = get(wv_free, 'ampli');
        ph_free(n)  = get(wv_free, 'phase');
        wv_free = phase_shift(wv_free, pi);
        wv_1st = correc(n) * wv_1st;
        wv_2nd = wv_1st + wv_free;
        N_shift = 3;
    else
        wv_1st = correc(n) * wv_1st;
        N_shift = 1;
    end
    if remove_free_waves
        %% Second-order generation (corrected wave)
        m = N_shift*(n-1)+1; % index for .wav file
        % .dat file name
        file_n = fullfile('data',strcat(name, '_', num2str(m)));
        % ocean 2000 components rules
        ocean_write_summary_data(fid_sum, m, wv_2nd)
        N_2000 = export(wv_2nd, 'ocean', fullfile(path,file_n));
        % data text
        ocean_write_data_read(fid, file_n, m, N_2000)
    end
    %% Linear generation (uncorrected wave)
    m = N_shift*(n-1)+1+remove_free_waves; % index for .wav file
    % .dat file name
    file_n = fullfile('data',strcat(name, '_', num2str(m)));
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, m, wv_1st)
    N_2000 = export(wv_1st, 'ocean', fullfile(path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, m, N_2000)
    if remove_free_waves
        %% Correction only
        m = N_shift*(n-1)+3; % index for .wav file
        % .dat file name
        file_n = fullfile('data',strcat(name, '_', num2str(m)));
        % ocean 2000 components rules
        ocean_write_summary_data(fid_sum, m, wv_free)
        N_2000 = export(wv_free, 'ocean', fullfile(path,file_n));
        % data text
        ocean_write_data_read(fid, file_n, m, N_2000)
    end
end
if remove_free_waves
    a_free
    ph_free
end
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
for n=runs
    run_title = build_run_title(n, periods(n), 2*amplis(n));
    m = N_shift*(n-1)+1; % index for .wav file
    if remove_free_waves
        ocean_write_run(fid, [run_title, ', 2nd-order wmk'], rnum, m)
    else
        ocean_write_run(fid, run_title, rnum, m)
    end
end
if remove_free_waves
    for n=runs
        run_title = build_run_title(n, periods(n), 2*amplis(n));
        m = N_shift*(n-1)+2; % index for .wav file
        ocean_write_run(fid, [run_title, ', 1st-order wmk'], rnum, m)
    end
    for n=runs
        run_title = build_run_title(n, periods(n), 2*amplis(n));
        m = N_shift*(n-1)+3; % index for .wav file
        ocean_write_run(fid, [run_title, ', correction only'], rnum, m)
    end
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

rmpath ../classes
rmpath(genpath('../lib'))


function run_title = build_run_title(n, T, H)
run_title = ['WC-R', num2str(n), ' T=', num2str(T,3), 's, H=', num2str(H,3), 'm'];


