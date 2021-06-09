function [y, time] = logger_read_data(fid, keyword, N)
% fid       valid file identifier
% keyword   either 'DATA::', 'ZEROS::' or 'EVENTS::'
% N         number of measured signals
%
% y         data array
% time      time vector
%
% See also logger_read_acquisition
%
if strcmp(keyword,'EVENTS::')
    N = 0;
end
frewind(fid);
line_keyword = logger_read_keyword(fid, keyword);
%
y      = fscanf(fid,'%f');
n_samp = floor(length(y) / (N+1));
y      = reshape(y, [N+1,n_samp]).';
time   = y(:,1);
y      = y(:,2:end);
