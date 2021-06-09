function wait_time_bar(handle, x, title)
%
time = toc;
time = time * (1-x) / (x+1.0e-12);
hour = floor(time / 3600);
min  = floor((time - hour * 3600) / 60);
sec  = floor((time - hour * 3600 - min * 60) / 5);
if min == 0 && hour == 0 && sec < 1
    sec  = floor(time);
else
    sec = (sec + 1) * 5;
    if sec == 60
        min = min + 1;
        if min == 60
            hour = hour + 1;
            min = 0;
        end
        sec = 0;
    end
end

if nargin < 3
    waitbar(x,handle, ['Remaining time ' num2str(hour) ' h ' num2str(min,'%02i') ' m ' num2str(sec,'%02i') ' s.'])
else
    waitbar(x,handle, [title '. Remaining time ' num2str(hour) ' h ' num2str(min,'%02i') ' m ' num2str(sec,'%02i') ' s.'])
end
