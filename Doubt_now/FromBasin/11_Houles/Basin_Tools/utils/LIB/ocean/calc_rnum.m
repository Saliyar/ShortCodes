function y = calc_rnum(T_repeat, clock)
%CALC_RNUM gives rnum form T_repeat
%   y = calc_T_repeat(T_repeat, clock)
%   evaluates the repeat number of an experiment prepared with the ocean
%   software
if nargin == 2
    y = nextpow2(T_repeat) + nextpow2(clock);
else
    % using the default 32 Hz clock
    y = nextpow2(T_repeat) + 5;
end