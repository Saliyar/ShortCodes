%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Force comparision from experiment and foamStar
close all
clc 
clear
%% Experimental results loading
load('/home/saliyar/Documents/Working/ISOPEtestcase/Category A/Case23003/cylinnonbreak23003_2ndorder_9600Hz.MAT')
A=Channel_10_Data;
Force_in_volts=Channel_11_Data;
Force_in_N=Force_in_volts*2455.5;

plot(A,Force_in_N)