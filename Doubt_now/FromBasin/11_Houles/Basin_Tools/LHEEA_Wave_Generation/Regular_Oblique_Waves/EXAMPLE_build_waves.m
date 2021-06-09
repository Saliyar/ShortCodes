function BV_2018_build_waves
%
series = 4; %1= initial file, 2= correction from 26/02/2018 tests
%
[periods, amplis, Holambda, lambdaoH, correc, rnum, name, lambdaoL] = BV_2018_define_waves(series);
%
T_repeat = calc_T_repeat(rnum);
%
harmo_target = floor(T_repeat ./ periods);
%
wmk  = wavemaker('ECN_wave');
%
path = prepare_ocean_folder(fullfile('..\wmk\', name));
%
% Experiment title, will appear in wavemaker GUI
title = strcat('Regular waves for BV experiments');
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
    %% Correction
    wv_free = eval_free_waves(wv_1st, 400, 'hinged');
    a_free(n)  = get(wv_free, 'ampli');
    ph_free(n)  = get(wv_free, 'phase');
    wv_free = phase_shift(wv_free, pi);
    wv_1st = correc(n) * wv_1st;
    wv_2nd = wv_1st + wv_free;
    %% Linear generation (uncorrected wave)
    m = 3*(n-1)+1; % index for .wav file
    % .dat file name
    file_n = fullfile('data',strcat(name, '_', num2str(m)));
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, m, wv_2nd)
    N_2000 = export(wv_2nd, 'ocean', fullfile(path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, m, N_2000)
    %% Second-order generation (corrected wave)
    m = 3*(n-1)+2; % index for .wav file
    % .dat file name
    file_n = fullfile('data',strcat(name, '_', num2str(m)));
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, m, wv_1st)
    N_2000 = export(wv_1st, 'ocean', fullfile(path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, m, N_2000)
    %% Correction only
    m = 3*(n-1)+3; % index for .wav file
    % .dat file name
    file_n = fullfile('data',strcat(name, '_', num2str(m)));
    % ocean 2000 components rules
    ocean_write_summary_data(fid_sum, m, wv_free)
    N_2000 = export(wv_free, 'ocean', fullfile(path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, m, N_2000)
end
a_free
ph_free
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
for n=runs
    lambdaoL_text = build_lambdaoL_text(lambdaoL(n));
    m = 3*(n-1)+1; % index for .wav file
    run = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, 2nd-order wmk'];
    ocean_write_run(fid, run, rnum, m)
end
for n=runs
    lambdaoL_text = build_lambdaoL_text(lambdaoL(n));
    m = 3*(n-1)+2; % index for .wav file
    run = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, 1st-order wmk'];
    ocean_write_run(fid, run, rnum, m)
end
for n=runs
    lambdaoL_text = build_lambdaoL_text(lambdaoL(n));
    m = 3*(n-1)+3; % index for .wav file
    run = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '% correction only'];
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

