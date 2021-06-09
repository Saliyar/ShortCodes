function y = calc_T_repeat(rnum, clock)
% y = calc_T_repeat(rnum, clock)
% evaluates the repeat period of an experiment prepared with the ocean
% software
if nargin == 2
    y = pow2(rnum) / clock;
else
    % using the default 32 Hz clock
    y = pow2(rnum) / 32;
end