function display(p)
% PROJET/DISPLAY Command window display of a projet
disp(['Project name: ' p.name]);
disp(['Project path: ' p.path]);
disp(['Measurement files path: ' p.pathMeas]);
disp(['Results files path: ' p.pathRes]);
disp(['Figure files path: ' p.pathFig]);
disp(['Number of tests: ' num2str(length(p.fileList))]);
