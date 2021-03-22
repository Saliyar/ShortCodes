function [Tn,X,zeta]=logDecrement(Xaxis,Yaxis,n)


[pks,locs] = findpeaks(Yaxis,'MinPeakHeight',0.0075,'MinPeakDistance',700);
length(pks)
% FigH = figure('Position', get(0, 'Screensize'));
% 
% plot(Xaxis,Yaxis,Xaxis(locs),pks,'or','LineWidth',3)
% ylabel('Time series','interpreter','latex','FontSize',32)
% xlabel('Time [s]','interpreter','latex','FontSize',32)
% set(gca,'Fontsize',32)
% title ('Decay','interpreter','latex','FontSize',32);
%     grid on;
% axis tight

%% Determine log decremement for each peaks and plot
for i=1:length(pks)-n
del(i)=(1/n)*log((pks(i))/(pks(i+n)));
X(i)=Xaxis(locs(i));
zeta(i)=1/sqrt(1+(2*pi/del(i))^2)*100;

end



%% Determine the Natural period

for i=1:length(pks)-1
    Nat_period(i)=Xaxis(locs(i+1))-Xaxis(locs(i))
end

Tn=mean(Nat_period);

fprintf('The damped Natural period is %f(s) \n',Tn);

