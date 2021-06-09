function plotTrajSpeedAcc(t,pdf)
% PLOT opens a figure and plot the trajectories positions, speeds
% and accelerations. It returns 0 if the pos, speeds and acc are within the
% limits. It returns 1 if the trajectories is beyond the limits
disp('Plots positions, speeds and acceleration...');
temps = [0:t.dt:(length(t.pos)-1)*t.dt];

limPos = [460 460 400 30 30 40];    %limites en mm et deg
limVit = [1000 1000 650 50 50 70];  %limite en mm/s et deg/s
limAcc = [10000 10000 8000 500 500 700];     %limite en m/s2 et deg/s2

for col = 1:6
	vit(:,col) = diff(t.pos(:,col))/t.dt;
    acc(:,col) = diff(vit(:,col))/t.dt;
end

nomCol = {'X' 'Y' 'Z' 'Rx' 'Ry' 'Rz'};
unit = {'mm' 'mm' 'mm' 'deg' 'deg' 'deg'};
unitVit = {'mm/s' 'mm/s' 'mm/s' 'deg/s' 'deg/s' 'deg/s'};
unitAcc = {'mm/s^2' 'mm/s^2' 'mm/s^2' 'deg/s^2' 'deg/s^2' 'deg/s^2'};
chemin = 'C:\Users\johana.IFR\Documents\__MATLAB-OUTPUT\';

%Trajectoires positions----------------------------------
%---------------------------------------------------
figure('PaperType','A4','Units', 'centimeters', 'Position', [3 1 14 19.8]);
tit = sprintf('Hexapode trajectory\n%s',t.name);

for kk = 1 : 6        
    ax(kk) = subplot(6,1,kk);
    axpos = get(ax(kk),'Position');
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
    axpos2 = [axpos(3)+0.15 axpos(2) 0.8-axpos(3) axpos(4)];
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

%Vitesses------------------------------------------------------------------
%--------------------------------------------------------------------------
figure('PaperType','A4','Units', 'centimeters', 'Position', [3 1 14 19.8]);
tit = sprintf('Hexapode trajectory speeds\n%s',t.name);
for kk = 1 : 6        
    ax(kk) = subplot(6,1,kk);
    axpos = get(ax(kk),'Position');
    axpos(3) = axpos(3)*0.8;
    set(ax(kk),'Position',axpos);

    plot(temps(1:end-1),vit(:,kk)); hold on; grid on;    
    ylabel([nomCol{kk} ' (' unitVit{kk} ')']);  
    v = axis;
    plot([v(1) v(2)],[limVit(kk),limVit(kk)],'r');
    plot([v(1) v(2)],[-limVit(kk),-limVit(kk)],'r');
    if kk == 1
        title(tit);
    end
    if kk == 6
        xlabel('time (sec)');  
    end
    ma(kk) = max(vit(:,kk));
    mi(kk) = min(vit(:,kk));
    stdev(kk) = std(vit(:,kk));
    avg(kk) = mean(vit(:,kk));       
    axpos2 = [axpos(3)+0.15 axpos(2) 0.8-axpos(3) axpos(4)];
    axes('Position',axpos2,'Visible','Off');
    tex = sprintf('max = %2.1f %s\nmin = %2.1f %s\nstd = %2.1f %s\navg = %2.1f %s',ma(kk),unitVit{kk},mi(kk),unitVit{kk},stdev(kk),unitVit{kk},avg(kk),unitVit{kk});       
    text(0,0.5,tex);  
         
end
linkaxes(ax,'x');
zoom on;
orient tall;
if(pdf == 1)
    print ('-dpdf', [chemin 'HexaTrajSpeed' t.name]);
end

%Accelerations-------------------------------------------------------------
%--------------------------------------------------------------------------
figure('PaperType','A4','Units', 'centimeters', 'Position', [3 1 14 19.8]);
tit = sprintf('Hexapode trajectory Accelerations\n%s',t.name);
for kk = 1 : 6        
    ax(kk) = subplot(6,1,kk);
    axpos = get(ax(kk),'Position');
    axpos(3) = axpos(3)*0.8;
    set(ax(kk),'Position',axpos);
    plot(temps(1:end-2),acc(:,kk)); hold on; grid on;    
    ylabel([nomCol{kk} ' (' unitAcc{kk} ')']);  
    v = axis;
    plot([v(1) v(2)],[limAcc(kk),limAcc(kk)],'r');
    plot([v(1) v(2)],[-limAcc(kk),-limAcc(kk)],'r');
    if kk == 1
        title(tit);
    end
    if kk == 6
        xlabel('time (sec)');  
    end
    ma(kk) = max(acc(:,kk));
    mi(kk) = min(acc(:,kk));
    stdev(kk) = std(acc(:,kk));
    avg(kk) = mean(acc(:,kk));       
    axpos2 = [axpos(3)+0.15 axpos(2) 0.8-axpos(3) axpos(4)];
    axes('Position',axpos2,'Visible','Off');
    tex = sprintf('max = %2.1f %s\nmin = %2.1f %s\nstd = %2.1f %s\navg = %2.1f %s',ma(kk),unitAcc{kk},mi(kk),unitAcc{kk},stdev(kk),unitAcc{kk},avg(kk),unitAcc{kk});       
    text(0,0.5,tex);  
         
end
linkaxes(ax,'x');
zoom on;
orient tall;
if(pdf == 1)
    print ('-dpdf', [chemin 'HexaTrajAcc' t.name]);
end
disp('Done.');

