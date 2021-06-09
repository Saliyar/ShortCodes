function val = SIGtrouveInterv1(s,T)
%TROUVEINTERV1 trouve Tdeb et Tfin pour le signal s de prédiode T
%type "essai d'étalonnage dynamique" c'est à dire
%signal monochromatique avec rampe de début et fin
%on renvoie tdeb et tfin
%Il parcourt le signal avec un fenêtre de 1 seconde
%à chaque étape il calcule l'ecart type
%le vecteur resultant est filtré et on choisit tdeb et tfin
%comme étant la 1ere valeur à 90% du max ...

%Affichage du signal----------------------------------------
nbPoints = length(s.Y);
temps = [0:s.dt:(nbPoints-1)*s.dt];

figure;
subplot(2,1,1);
plot(temps,s.Y);hold on; grid on;
ylabel([s.nom ' (' s.unite ')']);
xlabel('Time (sec)');
zoom on;
%v = axis;

%fenetre d'analyse----------------------------------------
largFen = 100;   %en nb d'echantillons
ind1 = 1;
%re = rectangle('Position',[temps(ind1) v(3) temps(ind1+largFen) v(4)-v(3)],'EdgeColor','r');

for k = 1 : nbPoints-largFen   
    ind1 = k;
    %set(re,'Position',[temps(ind1) v(3) largFen*s.dt v(4)-v(3)]);
    %pause(0.001);   
    fen = s.Y(ind1:ind1+largFen);
    ecartTypeFen(k) = std(fen);
end

subplot(2,1,2);
plot(temps(1:length(ecartTypeFen)),ecartTypeFen,'g');hold on;

%Filtrage par Butterworth--------------------------------------
fech = 1/s.dt;              %freq echantillonnage
df = fech/nbPoints;         %pas frequentiel
freq = 0:df:fech/2-df;      %definition du vecteur freq

fc = 0.5;
fcnorm = fc/50;
[b,a] = butter(4,fcnorm,'low');

h=freqz(b,a,freq,100);

% figure('Units', 'centimeters', 'Position', [17 1 15 20]);
% semilogy(freq,abs(h));
% xlim([0 5]);grid on;zoom on;

sigfilt = filtfilt(b,a,ecartTypeFen);
sigfilt = filtfilt(b,a,sigfilt);
sigfilt = filtfilt(b,a,sigfilt);

% figure;
% plot(temps(1:length(ecartTypeFen)),ecartTypeFen,'b');hold on;grid on;
% plot(temps(1:length(sigfilt)),sigfilt,'r');
% zoom on;

plot(temps(1:length(sigfilt)),sigfilt,'r');
v = axis;
%on a le vecteur des ecarts type on cherche tdeb et tfin---------
m = max(sigfilt);
ind = find(sigfilt>m*0.9);
tdeb = (ind(1)+largFen) * s.dt;
tfin = (ind(end)) * s.dt;

rectangle('Position',[tdeb v(3) tfin-tdeb v(4)-v(3)],'EdgeColor','r');

subplot(2,1,1);
plot(temps,s.Y);hold on; grid on;
ylabel([s.nom ' (' s.unite ')']);
xlabel('Time (sec)');
zoom on;
v = axis;
rectangle('Position',[tdeb v(3) tfin-tdeb v(4)-v(3)],'EdgeColor','r');

nbPeriod = floor((tfin-tdeb)/T);
tfin = tdeb + (nbPeriod*T);

val = [tdeb tfin];
