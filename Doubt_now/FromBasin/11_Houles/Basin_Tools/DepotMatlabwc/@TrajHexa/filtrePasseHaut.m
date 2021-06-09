function val = filtrePasseHaut(t,voie,fc,ordre,display)
% filtrePasseHaut retire la composante continue du signal
%classiquement ordre = 4 et fc = 0.02

disp('High Pass Filtering...');

dataFilt = t.pos;
%préparation du filtre
fcnorm = fc/50;
[b,a] = butter(ordre,fcnorm,'high');
%filtrage de la colonne 2
dataFilt(:,voie) = filtfilt(b,a,dataFilt(:,voie));

if display == 1
    figure('PaperType','A4','Units', 'centimeters', 'Position', [1 1 15 20]);
    temps = [0:t.dt:(length(t.pos)-1)*t.dt];
    nomCol = {'X' 'Y' 'Z' 'Rx' 'Ry' 'Rz'};
    unit = {'mm' 'mm' 'mm' 'deg' 'deg' 'deg'};
    chemin = 'E:\MatlabOutput\';
    tit = sprintf('High Pass Filtered Hexapode trajectory\n%s',t.name);
    ind = 1;
    for kk = 1 : 6        
        ax = subplot(6,1,kk);
        plot(temps,t.pos(:,kk)); hold on; grid on; 
        ylabel([nomCol{kk} ' (' unit{kk} ')']);  
        if kk == voie(ind)
            plot(temps,dataFilt(:,kk),'r');           
            legend('raw data', 'filtered data');
        end
        if kk == 1
            title(tit);
        end
        if kk == 6
            xlabel('time (sec)');  
        end
      
    end
    linkaxes(ax,'x');
    zoom on;
    orient tall;
end

val = trajHexa(t.name,dataFilt,t.dt);
disp('Done.');