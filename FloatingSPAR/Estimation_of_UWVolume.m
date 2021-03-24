%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code for calucalting underwater volume of the floating body
%% Clearing the screen

close all
clc 
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constant Inputs
D_spar=0.45; 
D_tower=0.28;
Coning_height=0.2;
L_Spar=1.95;



%% VaryingInput
Overall_Draft=2.285;
OF_alphafieldVolume=3.6110593e+01;
Domain_Length=2.7;
Domain_width=2.7;
Domain_Waterdepth=5;
Density=1000;
Mass_entered=329.4;
%% Solid Volume calucaltion
Diff_height=Overall_Draft-L_Spar
r_spar=D_spar/2;
r_tower=D_tower/2;
Vol_SPAR= pi/4 * D_spar^2 * L_Spar;


if (Diff_height>0.2)

    %In any case SPAR will not come out of water - So its underwater volume is fixed 
   
    Vol_cone= 1/3 * pi * Coning_height * (r_tower^2+r_tower*r_spar+r_spar^2);
    h_tower=Diff_height-0.2;
    Vol_tower = pi/4 * D_tower^2 *h_tower;
    Total_Volume= Vol_cone+Vol_SPAR+Vol_tower;

else
   Coning_height=Diff_height;
    Vol_cone= 1/3 * pi * Coning_height * (r_tower^2+r_tower*r_spar+r_spar^2);
    Total_Volume= Vol_cone+Vol_SPAR;
end

disp('********************Volume Comparision**********************')

fprintf('Theoratical Total submerged volume is %f(cu.m) \n',Total_Volume);

OF_Volume=  (Domain_Length*Domain_width*Domain_Waterdepth)-OF_alphafieldVolume;

fprintf('OF Total submerged volume is %f(cu.m) \n',OF_Volume);

Diff_Volume=Total_Volume-OF_Volume;


fprintf('Difference in  Total submerged volume in foamstar is %f (cu.m) \n',Diff_Volume);


Percentage_Volumeloss= (Diff_Volume/Total_Volume)*100;

fprintf('The percentage loss in Volume from OF and Theory is %f  \n \n',Percentage_Volumeloss);

disp('*****************Mass comparision***********************')

Diff_mass= Diff_Volume*Density;

Theoratical_mass=Total_Volume*Density;

fprintf('Theoratical Total mass is %f (kg) \n',Theoratical_mass);

fprintf('foamstar input, mass entered in the dict is %f (kg) \n',Mass_entered);

OF_mass=OF_Volume*Density;

fprintf('OF Total mass is %f (kg) \n',OF_mass);

fprintf('Difference in  Total  mass in foamstar is %f (kg) \n \n',Diff_mass);


disp('*****************Draft comparision***********************')


Diff_draft=(Diff_Volume/(pi/4 * D_tower^2))*100;

fprintf('Difference in draft in Tower is %f (cm) \n',Diff_draft);



