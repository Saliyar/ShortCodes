function val = rampeSin(t,dureeRampe,display)
% rampeSin applique une rampe de forme sinus de la duree duree
%au début et à la fin des trajectoires

disp('Sinus shaped ramp application...');

temps = [0 : t.dt : (length(t.pos)-1)*t.dt];
rampe = ones(length(t.pos),1);
nbPointsRampe =  round(dureeRampe/t.dt);

T = 2*dureeRampe;
montee = -cos(2*pi/T*temps(1:nbPointsRampe))/2+0.5;
rampe([1:nbPointsRampe]) = montee;
descente = fliplr(montee);
rampe([(end-nbPointsRampe+1):end])= descente;

for k = 1 : 6
    posRampe(:,k) = t.pos(:,k) .* rampe;
end
    
if display == 1
    figure('PaperType','A4','Units', 'centimeters', 'Position', [1 1 15 20]);
    temps = [0:t.dt:(length(t.pos)-1)*t.dt];
    nomCol = {'X' 'Y' 'Z' 'Rx' 'Ry' 'Rz'};
    unit = {'mm' 'mm' 'mm' 'deg' 'deg' 'deg'};
    chemin = 'E:\MatlabOutput\';
    tit = sprintf('Windowed Hexapod trajectory\n%s',t.name);
    for kk = 1 : 6        
        ax(kk) = subplot(6,1,kk);
        plot(temps,t.pos(:,kk)); hold on; grid on; 
        ylabel([nomCol{kk} ' (' unit{kk} ')']);  
        plot(temps,posRampe(:,kk),'r');           
        legend('raw data', 'windowed data');    
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

val = trajHexa(t.name,posRampe,t.dt);
disp('Done.');