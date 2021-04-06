function [time_Sriram,PP_Sriram] =loadExpDataSriram(fileMatExp)


load(fileMatExp)

PP_Sriram=[pp2(:,2) pp2(:,2) pp3(:,2) pp4(:,2) pp5(:,2) pp6(:,2) pp7(:,2) pp8(:,2)];
time_Sriram = pp2(:,1); % same times for all exp probes;
