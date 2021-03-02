%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% To understand the Phase shift %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
figure()
t = linspace(0,2*pi) ;
x = sin(pi/4*t) ;
plot(t,x,'r')
hold on
x = sin(pi/4*t+3.078215384) ;  % phase shift by pi/2, which is same as cos 
plot(t,x,'b')