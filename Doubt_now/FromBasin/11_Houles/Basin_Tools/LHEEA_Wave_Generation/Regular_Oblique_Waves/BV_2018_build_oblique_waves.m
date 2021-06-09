function BV_2018_build_oblique_waves
%
series = 5; %1= initial file, 2= correction from 26/02/2018 tests
export_2_HOS = 0;
%
[periods, amplis, Holambda, lambdaoH, correc, rnum, name, lambdaoL, direction] = BV_2018_define_waves(series);
X_d = 17; % m, target distance for Dalrymple method

%% Parameters
wave_basin = 'ECN_wave'; % among 'ECN_wave', 'ECN_towing', or 'ECN_small'
wmk  = wavemaker(wave_basin);

%
T_repeat = calc_T_repeat(rnum);
%
harmo_target = floor(T_repeat ./ periods);

%
path = prepare_ocean_folder(fullfile('..\wmk\', name));
%
% Experiment title, will appear in wavemaker GUI
title = strcat('Regular oblique waves for BV experiments');
routine = mfilename; % for reference in the .wav files
%
fid = ocean_write_header(fullfile(path, name), title, routine);
fid_sum = ocean_write_summary_header(fullfile(path, name), title, routine, 'nantes_main_posn/default.ttf');
%
runs = 1:length(periods);
%
for n=runs
    %% linear wavemaker thery
    harmo = harmonic(harmo_target(n), amplis(n), [], direction(n));
    wv_1st = wave(T_repeat, 16, harmo, wmk, control_law(0,'dalrymple', X_d));
    if export_2_HOS
        % export for HOS
        export(wv1st, 'cfgdat', fullfile(path, 'data', strcat(name, '_HOS', '_', num2str(n))));
    end    
    %% Correction of the transfer function
    wv_1st = correc(n) * wv_1st;
    %% Linear generation (uncorrected wave)
    m = n; % index for .wav file
    % .dat file name
    file_n = fullfile('data',strcat(name, '_', num2str(m)));
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, m, wv_1st)
    N_2000 = export(wv_1st, 'ocean', fullfile(path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, m, N_2000)
end
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
for n=runs
    lambdaoL_text = build_lambdaoL_text(lambdaoL(n));
    m = n; % index for .wav file
    run = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, dir=', direction(n), ', 1st-order wmk'];
    ocean_write_run(fid, run, rnum, m)
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

function lambdaoL_text = build_lambdaoL_text(lambdaoL)
lambdaoL_text = strrep(num2str(lambdaoL,3), '.', 'p');
if strcmp(lambdaoL_text, '1') || strcmp(lambdaoL_text, '2')
    lambdaoL_text = [lambdaoL_text, 'p0'];
end

