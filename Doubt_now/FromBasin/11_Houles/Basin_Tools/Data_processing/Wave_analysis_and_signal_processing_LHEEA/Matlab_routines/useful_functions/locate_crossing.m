function [i j] = locate_crossing(data,v)
% find the points where data crosses the given 'v' level
% Inputs
%  data: a matrix
%  v: level (optional) v=0 is the default value if omitted

%data = make_it_column(data);
%
if nargin < 2
    v = 0;
end
%
sign_data = sign(data - v);
[i j] = find(sign_data(1:end-1,:) .* sign_data(2:end,:) <= 0);