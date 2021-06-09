% LHEEA_addpath4basin_tools
% script to add the relevant libraries to the MATLAB path
addpath(genpath('utils'))
addpath('LHEEA_Wave_Generation', ...
    'LHEEA_Wave_Generation\Irregular_Directional_Waves', ...
    'LHEEA_Wave_Generation\Regular_Oblique_Waves')
% command to remove the symbolic toolbox path to the harmonic function
A = ver('symbolic');
if ~isempty(A)
    if license('test',A.name)
        rmpath([matlabroot '/toolbox/symbolic/symbolic']);
    end
end