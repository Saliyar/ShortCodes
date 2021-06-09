function data = complete_vector(data,s)
% complete the data with the last terms if the required size "s" is greater
% than the actual size of data
if ~isempty(data)
    if length(data) < s
        data(length(data)+1:s) = data(length(data));
    elseif length(data) > s
        data = data(1:s);
    end
end
    