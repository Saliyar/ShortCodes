function val = SIGSerFourLeastSquares(s,ordre,Ttheo)
%SERFOUR calcule les coefficients des séries de Fourier 
%du signal s à l'ordre n
%il renvoie un tableau contenant :
%1ere colonne : vecteur fréquences
%2e colonne : vecteur module des coef de Four
%3e colonne : vecteur phase des coef de Four

sig = s.Y;
Nf = ordre;                 %ordre des harmoniques
f0 = 1/Ttheo;               %freq fondamentale
lisFreq = [1:Nf]*f0;        %Liste des frequences
lisPuls = lisFreq*2*pi;     %Liste des pulsations
N = length(sig);    
temps = [0:s.dt:(N-1)*s.dt]';

% Construction of the system of the overconstrained system A X= B
%Calcul des coef pairs A-------------------------
A=ones(length(temps),1);
for k=1:Nf
   A=[A,cos(lisPuls(k)*temps)]; 
end
for k=1:Nf
   A=[A,sin(lisPuls(k)*temps)]; 
end

x = lsqlin(A,sig',[],[]);

a=x(2:Nf+1);
b=x(Nf+2:end);

% for k = 1:Nf
%     vect = sig.*(cos(lisPuls(k)*temps));
%     a(k) = sum(vect)*2/N;
% end
% %Calcul des coef impairs B----------------------
% for k = 1:Nf
%     vect = sig.*(sin(lisPuls(k)*temps));
%     b(k) = sum(vect)*2/N;
% end

%Calcul des coef de Fourier-------------
 for k = 1:Nf;
     coef(k) = a(k) +i*b(k);
     phaSerieF(k) = angle(a(k)-i*b(k));%(according to the ITTC 2002 recommended procedure : x(t)=cos(omega*t+phi), with phi the phase

 end
 
%Calcul des modules
modSerieF = abs(coef);
%calcul des phases
%phaSerieF = angle(coef);

val = [lisFreq; modSerieF; phaSerieF]';
