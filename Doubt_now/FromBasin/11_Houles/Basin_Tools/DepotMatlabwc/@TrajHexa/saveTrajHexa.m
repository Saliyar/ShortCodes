function saveTrajHexa(t)

%sauve les trajectoires dans un fichier texte 
%au format lisible par l'hexapode

dossier = 'C:\Users\johana.IFR\Documents\__MATLAB-OUTPUT\';

pos = get(t,'pos');
dt = get(t,'dt');
name = get(t,'name');
temps = [0 : dt : (length(pos)-1)*dt];


data = [temps' pos];

dlmwrite([dossier name '.txt'],data,'delimiter','\t','precision','%12.6f');



