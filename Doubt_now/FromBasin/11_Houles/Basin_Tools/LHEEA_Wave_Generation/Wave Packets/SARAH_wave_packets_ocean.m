function SARAH_wave_packets_ocean(runs, T_repeat, f_samp, eta, file_path,file_name, wave_basin, multiplier_linear,multiplier_nonlinear )

check_wavemaker_motion_speed = 1;
export_2_HOS = 1;

% wavemaker
wmk = wavemaker(wave_basin);
T_repeat_all = T_repeat;
rnum_all = log2(T_repeat_all)+5;

%% .wav file
% file_name name of the .wav file
file_header = file_name; % will appear in the client.exe windows

N_runs = size(eta, 2);

%% Wavemaker parameters

% output preparation
prepare_ocean_folder(file_path);
path_results=file_path ;%fullfile([file_path, '\', file_name])
routine = mfilename;
%
switch wave_basin
    case 'ECN_wave'
        ttf_file = 'nantes_main_posn/default.ttf';
    case 'ECN_towing'
        ttf_file = 'nantes_towing/towing_h2p9_v3.ttf';
    case 'ECN_small'
        ttf_file = 'nantes_twin/Twin_h094.ttf';
end
fid = ocean_write_header([path_results, '\', file_name], file_header, routine, ttf_file);
fid_sum = ocean_write_summary_header([path_results, '\', file_name], file_header, routine, ttf_file);
%
% wavemaker control law
%c_law = control_law(0, 'snake'); % Here no directions

for n = runs
    T_repeat = T_repeat_all(n);
    N_repeat = T_repeat * f_samp;
    
    file_name_suffix = ['_run_', num2str(n, '%02d')];
    
    % wave object
    harmo_target = 1:2*T_repeat;
    [ampli, freq] = Fourier(eta(1:N_repeat,n), f_samp);
    harmo = harmonic(harmo_target, abs(ampli), angle(ampli));
    
    nocorr =0;
    if nocorr
        wv_1st{n} = wave(T_repeat, f_samp, harmo, wmk);
        wv_2nd{n} = wv_1st{n}; % Riduclous
        wv_free{n} = wv_1st{n}; % Riduclous
    else
        
        [wv_1st{n}, wv_2nd{n}, wv_free{n}] = eval_wave_and_corrections(T_repeat, f_samp, harmo, wmk);
    end
    
    % correcting transfer function = nonlinear effects
    % before exporting to HOS
    wv_1st{n} = multiplier_nonlinear(n) * wv_1st{n};
    
    if export_2_HOS
        % export for HOS
        export( wv_1st{n}, 'cfgdat', fullfile(path_results,  [file_name '_HOS_1st' file_name_suffix]));
        export( wv_2nd{n}, 'cfgdat', fullfile(path_results,  [file_name '_HOS_2nd' file_name_suffix]));
    end
    
    
    if check_wavemaker_motion_speed
        % check the wavemaker motion
        LHEEA_check_wavemaker(wv_1st{n}, 20+n)
        LHEEA_check_wavemaker(wv_2nd{n}, 30+n)
    end
    % correcting transfer function = nonlinear effects
    % before exporting to HOS
    
    % correcting transfer function (gain) = wrong transfer function
    % specific to experimental wavemaker so after exporting to HOS
    
    
    wv_1st{n} = multiplier_linear(n) * wv_1st{n};
    wv_2nd{n} =  wv_1st{n} +  wv_free{n};
    
    
    % exporting to files
    %% Second-order generation (corrected wave)
    m = 3*(n-1)+1; % index for .wav file
    % .dat file name
    ocean_write_all( wv_2nd{n} , path_results, file_name, m, fid,fid_sum)
    run{m} = [build_run_title(n) ' 2nd-order wmk'];
    
    
    %% Linear generation (uncorrected wave)
    m = 3*(n-1)+2; % index for .wav file
    % .dat file name
    ocean_write_all(wv_1st{n}, path_results, file_name, m, fid,fid_sum)
    run{m} = [build_run_title(n) ' 1st-order wmk'];
    
    %% Correction only
    m = 3*(n-1)+3; % index for .wav file
    % .dat file name
    ocean_write_all(wv_free{n}, path_results, file_name, m, fid,fid_sum)
    run{m} = [build_run_title(n) ' correction only'];
    
end
%%
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
%% writing runs
for n=runs
    rnum = rnum_all(n);
    run_title = build_run_title(n);
    ocean_write_run(fid, run_title, rnum, n)
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

% warning('off', 'MATLAB:rmpath:DirNotFound')
% rmpath(path_lib)

function run = build_run_title(m)
run = ['Run', num2str(m)];

