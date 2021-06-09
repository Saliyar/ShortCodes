%% DECAY ANALYSIS 
% Troughs and crests
% initwafo
output=xlsread('C:\Users\varnal\ownCloud\STATIONIS\Simu\OrcaflexModel\decay test _pitch_5deg_wo_moorings.xls' );
Time_orcaflex=output(:,1);
Heave_orcaflex=output(:,2);

figure
plot(Time_orcaflex,Heave_orcaflex)
[t_clic x] = ginput(2);
for n=1:2
    add_vertical(t_clic, 'r')
end
Time=Time_orcaflex;
Ind_beg=find(abs(Time-t_clic(1))==min(abs(Time-t_clic(1))));
Ind_end=find(abs(Time-t_clic(2))==min(abs(Time-t_clic(2))));
hold off
% Selection of the good window:
Time = Time(Ind_beg:Ind_end)-Time(Ind_beg);
signal=Heave_orcaflex(Ind_beg:Ind_end)-mean(Heave_orcaflex(Ind_beg:Ind_end));
% initwafo
[TC, tc_ind, v_ind] = dat2tc(signal,0,'none');
freq=1/(Time(2)-Time(1));
TC(:,1)=TC(:,1)/freq;

title_DoF ={'Surge' 'Sway ' 'Heave' 'Roll' 'Pitch ' 'Yaw'};
title_units={' (m)',' (m)',' (m)',' (deg)','(deg)','(deg)'};
DoF=i;
figure
plot(Time,signal,'b-')
xlabel('Time (s)')
ylabel([title_DoF(DoF),title_units(DoF)])
title([title_DoF(DoF),'test'])
hold on
grid ON
plot(TC(:,1),TC(:,2),'ro','MarkerFaceColor',[1 0 0])
hold off

%% %==== FALTINSEN ANALYSIS=====%
max_pair_indice=2*floor(size(TC,1)/2);
TC=TC(1:max_pair_indice,:); % truncation
Tm1=TC(4,1)-TC(2,1);

X=TC(:,2);
if DoF==5
    factor=pi/180;
else
    factor=1;
end
for j = 2:max_pair_indice-1
    Tm(j-1)=TC(1+j,1)-TC(j-1,1);
   X_vector(j-1)=16/3*abs(X(j)*factor)/Tm1;
   Y_vector(j-1)=2/Tm1*log(abs(X(j-1))/abs(X(j+1)));
end
[Y_linear,S_regression]=polyfit(X_vector,Y_vector,1);
figure
Tm_average=mean(Tm);
plot(X_vector, Y_vector,'ko','MarkerFaceColor',[1 0 0])
xlabel('16/3 * X_n/Tm'); ylabel('2/Tm log(X_{n-1}/X_{n+1})')
grid ON

% %Use decay test
% Mass=1.402E+7;
% MA_90=8.76E+6;
% p2=Y_linear(1); p1=Y_linear(2);
% Blin=p1*(Mass+ MA_90)
% Bquad=p2*(Mass+ MA_90)
% 
% Kmoor_11_calc=4*pi^2*(Mass+MA_90)/(Tm_average^2) % MA should be increased by Added mass from mooring lines
%  END OF DECAY TEST ANALYSIS

%% %==== ITTC ANALYSIS=====%
