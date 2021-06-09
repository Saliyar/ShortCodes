function [filtered_data] = POMAP_freq_filter(data,method,state,f1,f2,order,R)

time = data(:,1);
spl = 1/(time(2) - time(1));

% f1 = f1/2/pi;
% f2 = f2/2/pi;

[m n] = size(data);
N_data = n;

Index_filter = 1;

if strcmp(method(1:3),'but')
    if strcmp(state(1:3),'low')
        Wn = f1/spl*2;
        [b,a] = butter(order,Wn,'low');
    elseif strcmp(state(1:3),'hig')
        Wn = f1/spl*2;
        [b,a] = butter(order,Wn,'high');
    elseif strcmp(state(1:3),'ban')
        fc = [f1 f2];
        Wn = fc/spl*2;
        [b,a] = butter(order,Wn);
    elseif strcmp(state(1:3),'sto')
        fc = [f1 f2];
        Wn = fc/spl*2;
        [b,a] = butter(order,Wn,'stop');
    else
        Index_filter = 0;
    end
    
elseif strcmp(method(1:3),'che')
    
    if strcmp(state(1:3),'low')
        Wn = f1/spl*2;
        [b,a] = cheby1(order,R,Wn,'low');
    elseif strcmp(state(1:3),'hig')
        Wn = f1/spl*2;
        [b,a] = cheby1(order,R,Wn,'high');
    elseif strcmp(state(1:3),'ban')
        fc = [f1 f2];
        Wn = fc/spl*2;
        [b,a] = cheby1(order,R,Wn);
    elseif strcmp(state(1:3),'sto')
        fc = [f1 f2];
        Wn = fc/spl*2;
        [b,a] = cheby1(order,R,Wn,'stop');
    else
        Index_filter = 0;
    end
else
    Index_filter = 0;
end

if Index_filter == 0    
    filtered_data = data;
else
    filtered_data(:,1) = time;
    for ij = 2:N_data        
        filtered_data(:,ij) = filtfilt(b,a,data(:,ij));
    end
end

end