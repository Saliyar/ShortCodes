function Err =computeErrors(time,num,ref,label)
if nargin<4
    label='';
end


figure(14)
hold off;
plot(time,num)
hold on;
plot(time,ref);

legend('num','ref');
title(label);

Err.RMSE= sqrt(mean((ref-num).^2));

RefArea = cumtrapz(ref.^2);
RefArea = RefArea(end);

ErrArea =  cumtrapz((ref-num).^2);
ErrArea = ErrArea(end);

Err.AbsAreaNorm2 = ErrArea;
Err.RelAreaNorm2 = ErrArea/RefArea;

Err.AbsMax = max(ref) -max(num);
Err.RelMax = Err.AbsMax / max(ref);  
