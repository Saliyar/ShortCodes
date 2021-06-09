function val = SIGSerFour2(s,ordre,Ttheo)
%SERFOUR calcule les coefficients des séries de Fourier
%du signal s à l'ordre n dans l'intervalle tdeb, tfin
%il renvoie un tableau contenant :
%1ere colonne : vecteur pulsations
%2e colonne : vecteur module des coef de Four
%3e colonne : vecteur phase des coef de Four

%SIGSerFour2 est comme SIGSerFour sans le découpage du signal

sig = s.Y;

% % % 
% % % %sigCoup = sig(round(tdeb*100):round(tfin*100))
% % % %Modifification to take a round number of periods in the analysed signal
% % % NT=floor((tfin-tdeb)/Ttheo);
% % % ideb=tdeb/s.dt;
% % % ifin=ideb+floor(NT*Ttheo/s.dt)-1;
% % % sigCoup = sig(ideb:ifin);
% % % 
% % % sig = sigCoup;

Nf = ordre;                 %ordre des harmoniques
f0 = 1/Ttheo;               %freq fondamentale
lisFreq = [1:Nf]*f0;        %Liste des frequences
lisPuls = lisFreq*2*pi;     %Liste des pulsations
N = length(sig);    
temps = [0:s.dt:(N-1)*s.dt]';


%Calcul des coef pairs A-------------------------
for k = 1:Nf
    vect = sig.*(cos(lisPuls(k)*temps));
    a(k) = sum(vect)*2/N;
end
%Calcul des coef impairs B----------------------
for k = 1:Nf
    vect = sig.*(sin(lisPuls(k)*temps));
    b(k) = sum(vect)*2/N;
end
%Calcul des coef de Fourier-------------
for k = 1:Nf;
    coef(k) = a(k) +i*b(k);
end
%Calcul des modules
modSerieF = abs(coef);
%calcul des phases
phaSerieF = angle(coef);


val = [lisFreq; modSerieF; phaSerieF]';
