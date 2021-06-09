function plot(t,pdf)
% PLOT opens a figure a plot the trajectories
temps = [0:t.dt:(length(t.pos)-1)*t.dt];
figure('PaperType','A4','Units', 'centimeters', 'Position', [3 1 14 19.8]);

nomCol = {'X' 'Y' 'Z' 'Rx' 'Ry' 'Rz'};
unit = {'mm' 'mm' 'mm' 'deg' 'deg' 'deg'};
chemin = 'C:\Users\johana.IFR\Documents\MATLAB\__MATLAB-OUTPUT\';
limPos = [460 460 400 30 30 40];    %limites en mm et deg
limVit = [1000 1000 650 50 50 70];  %limite en mm/s et deg/s
limAcc = [10000 10000 8000 500 500 700];     %limite en m/s2 et deg/s2

tit = sprintf('Hexapode trajectory\n%s',t.name);

for kk = 1 : 6        
    ax(kk) = subplot(6,1,kk);
    axpos = get(ax(kk),'Position')
    axpos(3) = axpos(3)*0.8;
    set(ax(kk),'Position',axpos);
    plot(temps,t.pos(:,kk)); hold on; grid on;    
    ylabel([nomCol{kk} ' (' unit{kk} ')']);
    v = axis;
    plot([v(1) v(2)],[limPos(kk),limPos(kk)],'r');
    plot([v(1) v(2)],[-limPos(kk),-limPos(kk)],'r');
    if kk == 1
        title(tit);
    end
    if kk == 6
        xlabel('time (sec)');  
    end
    ma(kk) = max(t.pos(:,kk));
    mi(kk) = min(t.pos(:,kk));
    stdev(kk) = std(t.pos(:,kk));
    avg(kk) = mean(t.pos(:,kk)); 
    axpos2 = [axpos(3)+0.15 axpos(2) 0.8-axpos(3) axpos(4)]
    axes('Position',axpos2,'Visible','Off');
    tex = sprintf('max = %2.1f %s\nmin = %2.1f %s\nstd = %2.1f %s\navg = %2.1f %s',ma(kk),unit{kk},mi(kk),unit{kk},stdev(kk),unit{kk},avg(kk),unit{kk});       
    text(0,0.5,tex);  
end
linkaxes(ax,'x');
zoom on;
orient tall;
if(pdf == 1)
    print ('-dpdf', [chemin 'HexaTraj' t.name]);
end

