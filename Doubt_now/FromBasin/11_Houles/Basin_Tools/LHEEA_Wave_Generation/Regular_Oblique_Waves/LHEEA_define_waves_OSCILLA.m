function [periods, amplis, correction, rnum, name] = LHEEA_define_waves_OSCILLA(series)

if nargin< 1
    % for test purposes
    series = 1;
end
%% water depth
depth  = 5;
%% wave definition
switch series
    case {1}
        % see files 180514_OSCILLA_PreparationDOC.xlsx and
        % 180515_LHEEA_Wave_Generation_OSCILLA.docx
        periods  = 1./[0.9375 0.9063 0.875 0.8438 0.8125 0.7813 0.75 0.7188 0.6875 0.6563 0.625 0.5938 0.5625 0.5313 0.5 0.4688 0.4375 0.4063 0.375 0.3438];
        periods = [periods periods];
        heights  = 2*[17.8 19 20.4 21.9 23.6 25.6 27.7 30.2 33 36.2 40 44.3 49.3 55.3 62.4 71 81.4 94.3 110.2 129.9]/1000;
        heights = [heights heights/2];
        amplis   = heights/2;
        initial_correc = 1.07 * ones(size(periods));
end
%% wave calibration
switch series
    case 1
        correction = initial_correc;
        name = 'Regular_waves'; % .wav file
end
%
%% parameter
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
fprintf(1, ['      kh= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], kh)
fprintf(1, ['      ka= ', repeat_format('%5.2g', length(periods), ', ') ,'\n'], ka)

