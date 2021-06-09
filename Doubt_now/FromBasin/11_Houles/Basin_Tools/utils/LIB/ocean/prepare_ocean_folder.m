function path_out = prepare_ocean_folder(path)
if ~exist(path, 'dir') && ~isempty(path)
    mkdir(path);
end
if ~exist(fullfile(path,'data'), 'dir')
    if ~isempty(path)
        mkdir(path, 'data');
    else
        mkdir('.\', 'data');
    end
end
path_out = path;