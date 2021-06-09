function format = repeat_format(format, N, delimiter)
if nargin < 3
    delimiter = '\t';
end
format = [repmat([format, delimiter],[1,N-1]), format];
