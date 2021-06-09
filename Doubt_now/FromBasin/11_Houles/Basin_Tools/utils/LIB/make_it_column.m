function data = make_it_column(data)
% data = make_it_column(data) 
% puts the data into a column vector
%
% Félicien Bonnefoy, LHEEA/ECN, april 2016
%
if size(data,1)~=1 && size(data,2)~=1
    warning('FeBo:make_it_column','make_it_column: The input data is not a vector')
end
if size(data,1) < size(data,2)
    data = data.';
end
