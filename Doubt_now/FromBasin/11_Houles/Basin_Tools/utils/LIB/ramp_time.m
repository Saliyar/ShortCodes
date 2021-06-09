%
% Function to apply a time ramp on a signal
%
function [data_ramp] = ramp_time(time,data,f_samp,T_ramp,ramp_loc,ramp_typ)
%
if strcmp(ramp_typ,'lin')
    ramp    = (0:1/f_samp:T_ramp - 1/f_samp/2) / T_ramp;
elseif strcmp(ramp_typ,'cos')
    x = (0:1/f_samp:T_ramp - 1/f_samp/2) / T_ramp * pi;
    ramp = (-cos(x)+1)/2;
else
    error('Unknown ramp type')
end
%
envelop = ones(size(data));
if (strcmp(ramp_loc,'beg') | strcmp(ramp_loc,'both'))
    %   start ramp
    envelop(time <= T_ramp- 1/f_samp/2) = ramp;
end
if (strcmp(ramp_loc,'end') | strcmp(ramp_loc,'both'))
    %   stop ramp
    envelop(time - 1/f_samp/2 >= time(end) - T_ramp - 0*1/f_samp/2) = fliplr(ramp(1:end));
end
% apply the envelop and remove the offset
% FIXME: it seems not suitable to remove offset in this case
data_ramp = (data - mean(data)) .* envelop;

end