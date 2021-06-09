function [periods, amplis, Holambda, lambdaoH, correction, rnum, name, lambda,directions] = MOCEAN_define_waves_correction(series,direction)



switch series
    case {1} % one column, lambda/L = 1
        % see file 180207_BV_SegmentedHull_test_matrix
        
        initial_correc = [1.05:0.01:1.2];
        periods  = 3.25* ones(size(initial_correc));
        Holambda = 100*[0.057]* ones(size(initial_correc));
        lambdaoH = 1./Holambda; 
        amplis   = [0.461779969312579]* ones(size(initial_correc));
        lambda = 16.372465012223400 * ones(size(initial_correc));
        
        directions = direction * ones(size(periods));

    case {3} % one column, lambda/L = 1
        % see file 180207_BV_SegmentedHull_test_matrix
        
        initial_correc = [0.95:0.01:1.05];
        periods  = 3.25* ones(size(initial_correc));
        Holambda = 100*[0.057]* ones(size(initial_correc));
        lambdaoH = 1./Holambda; 
        amplis   = [0.461779969312579]* ones(size(initial_correc));
        lambda = 16.372465012223400 * ones(size(initial_correc));
        
        directions = direction * ones(size(periods));
        
end
% wave calibration
switch series
    case 1
        correction = initial_correc;
        name = 'MOCEAN_19'; % .wav file
    case 2
        % measurement by JO and BB 26/02/2018
        % wave height estimation by wbw analysis and
        measured_defect = [0.961, 0.973, 0.975, mean([0.961, 0.960]), 0.931, 0.890, mean([0.841, 0.840, 0.845])];
        correction = initial_correc ./ measured_defect;
        fprintf(1, 'First correction (total) in %%\n')
        fprintf(1, ['   = ', repeat_format('%5.3g', length(periods), ', ') ,'\n'], correction)
        name = 'BV_2018_C1'; % .wav file
   
        
end       
if abs(direction)>0
    name = [name '_dir' num2str(direction)];
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
        fprintf(1, ['lambdaoL= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], lambda)
        
        
end