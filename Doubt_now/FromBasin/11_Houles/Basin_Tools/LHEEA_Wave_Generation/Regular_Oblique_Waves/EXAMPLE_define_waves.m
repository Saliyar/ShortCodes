function [periods, amplis, Holambda, lambdaoH, correction, rnum, name, lambdaoL] = Example_define_waves(series)

if nargin< 1
    % for test purposes
    series = 4;
end
%% wave definition
switch series
    case {1,2} % one column, lambda/L = 1
        % see file 180207_BV_SegmentedHull_test_matrix
        periods  = [1.68, 1.68, 1.67, 1.66, 1.64, 1.62, 1.59];
        Holambda = 100*[0.010, 0.021, 0.038, 0.052, 0.070, 0.087, 0.105];
        lambdaoH = [96, 47, 26, 19, 14, 11, 10];
        amplis   = [0.022990709, 0.046919916, 0.083529148, 0.11422695, 0.150770336, 0.185567387, 0.217344821];
        lambdaoL = 1 * ones(size(periods));
        initial_correc = 1.05 * ones(size(periods));
    case {3} % one lign, H/lambda = 0.021
        % see file 180207_BV_SegmentedHull_test_matrix
        periods  = [1.19, 1.45, 1.68, 1.87, 2.05, 2.22, 2.37, 2.52, 2.66];
        Holambda = 0.021 * ones(size(periods));
        lambdaoH = 47 * ones(size(periods));
        amplis   = [0.023, 0.035, 0.047, 0.058, 0.070, 0.082, 0.094, 0.105, 0.117];
        lambdaoL = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5];
        initial_correc = 1.08 * ones(size(periods)); % based on test case 2, HoL=2%, period=1.68s
    case {4} % one lign, H/lambda = 0.038
        % see file 180207_BV_SegmentedHull_test_matrix
        periods  = [1.19, 1.45, 1.68, 1.87, 2.05, 2.22, 2.37, 2.52, 2.66];
        Holambda = 0.0385 * ones(size(periods));
        lambdaoH = 26 * ones(size(periods));
        amplis   = [0.042, 0.063, 0.084, 0.104, 0.125, 0.146, 0.167, 0.187, 0.208];
        lambdaoL = [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5];
        initial_correc = 1.08 * ones(size(periods)); % based on test case 2, HoL=2.1%, period=1.68s
end
%% wave calibration
switch series
    case 1
        correction = initial_correc;
        name = 'BV_2018'; % .wav file
    case 2
        % measurement by JO and BB 26/02/2018
        % wave height estimation by wbw analysis and
        measured_defect = [0.961, 0.973, 0.975, mean([0.961, 0.960]), 0.931, 0.890, mean([0.841, 0.840, 0.845])];
        correction = initial_correc ./ measured_defect;
        fprintf(1, 'First correction (total) in %%\n')
        fprintf(1, ['   = ', repeat_format('%5.3g', length(periods), ', ') ,'\n'], correction)
        name = 'BV_2018_C1'; % .wav file
    case 3
        correction = initial_correc;
        name = 'BV_2018_Holambda_2pct'; % .wav file
    case 4
        correction = initial_correc;
        name = 'BV_2018_Holambda_3p8pct'; % .wav file
end
%% parameters
depth  = 5;
%
rnum = 15;
% 15 = 1024 s = 1 mHz
% 16 = 2048 s = 0.5 mHz
% 17 = 4096 s = 0.24 mHz
% 18 = 8192 s = 0.12 mHz
T_repeat = calc_T_repeat(rnum);
%
harmo_target = floor(T_repeat ./ periods);
T     = T_repeat ./ harmo_target;
freq  = 1./T;
k     = wave_number(freq, depth);
lambda = 2*pi./k;

kh = k*depth;
ka = k.* amplis;
%% display
fprintf(1, ['lambdaoH= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], lambdaoH)
fprintf(1, ['      kh= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], kh)
fprintf(1, ['      ka= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], ka)
fprintf(1, ['lambdaoL= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], lambdaoL)

