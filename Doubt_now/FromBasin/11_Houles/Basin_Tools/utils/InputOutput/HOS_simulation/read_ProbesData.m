function [time, eta] = read_ProbesData(path, file, header)
% read_data
%
% See also

if nargin < 2
    file = 'probes.dat';
end
if nargin < 3
    header = 2;
end
% HOS target probes data
A = textread(fullfile(path, file),'','commentstyle','shell','headerlines',header);
time  = A(:,1);
eta   = A(:,2:end);

