function data = make_it_row(data)
% puts the data into a row vector
% data = make_it_row(data) 
if size(data,1)~=0 && size(data,2)~=0
    if size(data,1)~=1 && size(data,2)~=1
        warning('make_it_row:nonvectordata', 'The input data is not a vector');
    end
    if size(data,1) > size(data,2)
        data = data.';
    end
end
