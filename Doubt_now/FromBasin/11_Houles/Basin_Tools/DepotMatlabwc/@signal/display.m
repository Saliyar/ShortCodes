function display(s)
% SIGNAL/DISPLAY Command window display of a projet
disp(['Nom du signal: ' s.nom]);
disp(['Unité : ' s.unite]);
 disp(['dt = ' num2str(s.dt)]);
 disp(['Nombre de points : ' num2str(length(s.Y))]);


