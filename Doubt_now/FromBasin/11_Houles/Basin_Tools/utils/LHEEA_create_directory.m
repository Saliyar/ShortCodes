function LHEEA_create_directory(file_path)
%
if ~exist(file_path, 'dir')
    mkdir(file_path);
end
if ~exist(fullfile(file_path,'data'), 'dir')
    mkdir(file_path, 'data');
end