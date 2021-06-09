function t_cross = locate_t_crossing(time, data, i_cross)
% find the exact zero-crossing
% by means of linear interpolation
%
t_cross = zeros(size(i_cross));
%
for n=1:length(i_cross)
    time_before = time(i_cross(n));
    data_before = data(i_cross(n));
    time_after  = time(i_cross(n)+1);
    data_after  = data(i_cross(n)+1);
    % linear interpolation
    t_cross(n) = time_before - (time_after-time_before) / (data_after-data_before) * data_before;
end
    