clear all
close all
clc

%% Generatin the cosine of values from 0 to 1
%% Code 1: Only Positive 
% %x=linspace(0,3.14159,10);
% for i=0:10
% x(i+1)=i*pi/10
% end
% y=sin(x);
% 
% %% Integrate the values - But it is positive side
% z=trapz(x,y)

%% Code 2 : Positive and Negative 
for i=0:10
x(i+1)=i*pi/10;
end
y=cos(x);
p=abs(y);
z=trapz(x,abs(y))

plot(x,y)
