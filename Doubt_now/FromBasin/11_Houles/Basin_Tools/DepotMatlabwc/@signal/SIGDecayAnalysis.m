function val = SIGDecayAnalysis(varargin)

% Syntax

%Vérification des arguments d'entrées-------------------------------
switch nargin
case 1 
    if (isa(varargin{1},'signal'))
        s = varargin{1};
    else
        error('Wrong type of input arguments')
    end      

    otherwise
   error('Wrong number of input arguments')
end

%Affichage du signal et sélection de la ROI
plot(s);
[x,y] = ginput(2);
ROI = [x,y]

%Affichage d'un planche résultat
s2 = SIGcut(s,ROI(1,1),ROI(2,1));
% plot(s2);

s2.Y = s2.Y - (mean(s2.Y));
% plot(s2);

data = s2.Y;
dt = s2.dt;
t = [0 : dt : dt*(length(data)-1)];
figure;
plot(t,data);

[up down] = wbw_analysis(t, data);


plot(t,data);





end






