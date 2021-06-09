clear all
BV_2018_build_waves;

path = '.\deploy\';
if ~exist(path, 'dir') 
    mkdir(path);
end

[M, Mex, C] = inmem('-completenames');

% Remove Matlab's own functions:
mroot    = matlabroot;
Mex(strncmpi(Mex, mroot, length(mroot))) = [];
C(strncmpi(C, mroot, length(mroot)))   = [];
M(strncmpi(M, mroot, length(mroot)))   = [];

for n=1:length(M)
    source = M{n};
    [pathstr,name,ext] = fileparts(source);
    if ~any(findstr(pathstr, '@'))
        % don't copy classes
        destination = [path, name, ext];
        copyfile(source, destination)
    else
        ind= findstr(pathstr, '@');
        destination = [path, pathstr(ind:end)];
        copyfile(pathstr, destination)        
    end
end