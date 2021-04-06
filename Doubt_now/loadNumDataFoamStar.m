function [time_num, PP_num_mbar] = loadNumDataFoamStar(path_num,num_case) 
shifttime = 0.1;

HydroPressure_mbar =[26.4558263041013,17.5870903041459,8.32753205924912,-0.00159322200032960,-0.0108529208989218,8.32753067767099,8.32753491870317,8.32753414046003];


% Num
data=readtable([path_num num_case '/probes/0/p']);
time_num=data{:,1}+shifttime; % why +0.1 ?
PP_num=data{:,2:end};

PP_num_mbar =PP_num *0.00980665;% Converting kg/ms2 to mbar
PP_num_mbar = PP_num_mbar - repmat(HydroPressure_mbar,length(PP_num),1);

figure(2)
plot(time_num, PP_num(:,:));