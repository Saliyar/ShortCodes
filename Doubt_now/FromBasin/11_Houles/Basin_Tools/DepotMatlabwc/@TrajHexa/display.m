function display(t)
% trajHexa DISPLAY Command window display of a trajHexa
disp(['Trajectory name: ' t.name]);
disp(['dt = ' num2str(t.dt)]);
disp(['Number of points : ' num2str(length(t.pos))]);


