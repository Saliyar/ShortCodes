function val = checkTraj(t)
%It returns 0 if the pos, speeds and acc are within the
%limits. It returns 1 if the trajectories is beyond the limits
disp('Checks positions, speeds and acceleration...');

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
chemin = 'E:\MatlabOutput\';

%Check---------------------------------------
%--------------------------------------------
val = 0;
for ii = 1 : 6
    if max(abs(t.pos(:,ii)))>=limPos(ii)
        val = 1;
        disp('Position limit exceeded');
    end
    if max(abs(vit(:,ii)))>=limVit(ii)
        val = 1;
        disp('Speed limit exceeded');
    end
    if max(abs(acc(:,ii)))>=limAcc(ii)
        val = 1;
        disp('Accel limit exceeded');
    end
end
if val == 1
    tex = sprintf('trajectory %s is WRONG!',t.name);
    disp(tex);
end

    
disp('Done.');