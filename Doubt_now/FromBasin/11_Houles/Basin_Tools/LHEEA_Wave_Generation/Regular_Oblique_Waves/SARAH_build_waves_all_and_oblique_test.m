function SARAH_build_waves_all_and_oblique(series,direction)
rmpath('C:\Program Files\MATLAB\R2016a\toolbox\symbolic\symbolic'); % Use in case of prob with harmonic
rmpath('C:\Program Files\MATLAB\R2018b\toolbox\symbolic\symbolic');
if nargin ==1
    direction =0;
end
%
%1= initial file, 2= correction from 26/02/2018 tests
%
export_2_HOS = 1;
X_d = 17; % m, target distance for Dalrymple method

[periods, amplis, Holambda, lambdaoH, correc, rnum, file_name, lambda, directions]= SARAH_define_waves_correction(series,direction);
%
T_repeat = calc_T_repeat(rnum);
harmo_target = floor(T_repeat ./ periods);
%
wmk  = wavemaker('ECN_wave');
%
path = prepare_ocean_folder(fullfile('\Results\', file_name));
%
% Experiment title, will appear in wavemaker GUI
title = strcat('Regular waves for BV experiments');
routine = mfilename; % for reference in the .wav files
%
fid = ocean_write_header(fullfile(path, file_name), title, routine);
fid_sum = ocean_write_summary_header(fullfile(path, file_name), title, routine, 'nantes_main_posn/default.ttf');
%
runs = 1:length(periods);
%
for n=runs
    lambdaoL_text = build_lambdaoL_text(lambda(n));
    file_name_suffix = ['_run_', num2str(n, '%02d')];
    if abs(directions(n)<0.01)

        harmo{n} = harmonic(harmo_target(n),amplis(n));
        [wv_1st{n}, wv_2nd{n}, wv_free{n}] = eval_wave_and_corrections(T_repeat, 16, harmo, wmk);

        if export_2_HOS
            % export for HOS
            export( wv_1st{n}, 'cfgdat', fullfile(path, 'dataRW', [file_name '_HOS_1st_' file_name_suffix]));
            export( wv_2nd{n}, 'cfgdat', fullfile(path, 'dataRW', [file_name '_HOS_2nd_' file_name_suffix]));
        end
        
        wv_1st{n} = correc(n) * wv_1st{n};
        wv_2nd{n} =  wv_1st{n} +  wv_free{n};  
        
        %% Second-order generation (corrected wave)
        m = 3*(n-1)+1; % index for .wav file
        % .dat file name
        ocean_write_all( wv_2nd{n} , path, file_name, m, fid)
        run{m} = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, 2nd-order wmk', ', S', num2str(series)];

        
        %% Linear generation (uncorrected wave)
        m = 3*(n-1)+2; % index for .wav file
        % .dat file name
        ocean_write_all(wv_1st{n}, path, file_name, m, fid)
        run{m} = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, 1st-order wmk', ', S', num2str(series)];

              
        %% Correction only
        m = 3*(n-1)+3; % index for .wav file
        % .dat file name
        ocean_write_all(wv_free{n}, path, file_name, m, fid)
        run{m} = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '% correction only', ', S', num2str(series)];

    else
        %% linear wavemaker thery
        harmo = harmonic(harmo_target(n), amplis(n), [], directions(n));
        wv_1st{n} = wave(T_repeat, 16, harmo, wmk, control_law(0,'dalrymple', X_d));
        
        if export_2_HOS
            % export for HOS
            export( wv_1st{n}, 'cfgdat', fullfile(path, 'data', strcat(file_name, '_HOS', '_', num2str(n))));
        end
        %% Correction of the transfer function
         wv_1st{n} = correc(n) *  wv_1st{n};
        %% Linear generation (uncorrected wave)
        m = n; % index for .wav file
        ocean_write_all(wv_1st{n}, path, file_name, m, fid)
        run{m} = [num2str(lambdaoH(n),2) '_', lambdaoL_text, ', H/lambda=', num2str(100*Holambda(n),3), '%, dir=', directions(n), ', 1st-order wmk'];

    end
end
% a_free
% ph_free
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');

for i=1:m
        ocean_write_run(fid, run{i}, rnum, i)
end

fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

function lambdaoL_text = build_lambdaoL_text(lambda)
lambdaoL_text = strrep(num2str(lambda,3), '.', 'p');
if strcmp(lambdaoL_text, '1') || strcmp(lambdaoL_text, '2')
    lambdaoL_text = [lambdaoL_text, 'p0'];
end

