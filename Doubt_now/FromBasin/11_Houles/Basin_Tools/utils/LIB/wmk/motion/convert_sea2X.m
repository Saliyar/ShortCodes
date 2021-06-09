function [time ang X] = convert_sea2X(file, ttf, theta, hinge)
% file      : nom du fichier .sea
% ttf       : nom du fichier .ttf 
% theta     : débattement maximal du batteur en radian (0.3 pour zone sur
% houle à l'ECN)
% hinge     : profondeur de la charnière
% Remarque : le fichier .ttf est à mettre dans
% le répertoire avec le fichier .sea, la routine convert_sea2X.m

% verification de la présence du fichier .ttf
if ~exist(ttf) % si le fichier n'existe pas
    status = dos(['copy %EDESIGN%\lib\' ttf ' ' pwd]);
    if status
        error('Le fichier ttf n''existe pas dans le répertoire')
    end
end
% info du fichier .sea
[pathstr,name,ext,versn] = fileparts(file);
% copie du fichier bin2def.exe
if ~exist('bin2def.exe') % si le fichier n'existe pas
    status = dos(['copy %EDESIGN%\bin2def.exe ' pwd]);
    if status
        error(['Le fichier bin2def.exe n''a pas été dans le répertoire %EDESIGN%. ' ...
                'Vérifiez que la variable d''environnement DOS %EDESIGN% existe bien. ' ...
                'Tapez >echo %EDESIGN% dans une fenêtre DOS.'])
    end
end
% convertir le fichier .sea en .ang
dos(['bin2def.exe -t ' ttf ' ' name '.sea ' name '.ang']);
% ouvrir le fichier .ang
fid = fopen([name '.ang'],'r');
% lire 9 lignes d'entête
for j=1:9
    fgetl(fid);
end
% lire la ligne "begin"
fgetl(fid); % begin
%
% First run
%
% lire la ligne "/* Run number 1: */"
fgetl(fid); % /* Run number 1: */
% lire la ligne suivante
cur_line  = fgetl(fid);
% lire le titre du run
ind_quote = regexp(cur_line,'"');
run_title = cur_line(ind_quote(1)+1:ind_quote(2)-1)
% lire le rnum éventuellement compressé
ind_with = regexp(cur_line,' with (');
ind_stop = regexp(cur_line(ind_with:length(cur_line)),',');
rnum = str2num(cur_line(ind_with+7:ind_with+ind_stop(1)-2))
% en déduire le nombre de points
n_pts = pow2(rnum);
% sauter 3 lignes
for j=1:3
    fgetl(fid);
end
% test sur la 4ème ligne
cur_line  = fgetl(fid);
if ~strcmp(cur_line(1:4), 'Unco')
    % lire une autre ligne
    fgetl(fid); % c'est le cas ou le rnum a été changé (données compressées)
end
% lire le mouvement
motion = fscanf(fid,'%i',[48 n_pts]).';
% fermer le fichier
fclose(fid);
% vecteur temps
time   = 0:1/32:(n_pts-1)/32;
% conversion du mouvement du volet central en angle
ang = (motion(:,24) - 2048) / 2048 * theta;
% affichage de la courbe angle = f(t)
figure(1), clf
plot(time, ang, 'b-')
% conversion du mouvement du volet central en position
X = ang * hinge;
% affichage de la courbe
figure(2), clf
plot(time, X)
