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
OF_Volume= 0.3;


%% Solid Volume calucaltion
Diff_height=Overall_Draft-L_Spar;
r_spar=D_spar/2;
r_tower=D_tower/2;
Vol_SPAR= pi/4 * D_spar^2 * L_Spar;


if (Diff_height>0.2)

    %In any case SPAR will not come out of water - So its underwater volume is fixed 
   
    Vol_cone= 1/3 * pi * Coning_height * (r^2+r*R+R^2);
    h_tower=Diff_height-0.2;
    Vol_tower = pi/4 * D_tower^2 *h_tower;
    Total_Volume= Vol_cone+Vol_SPAR+Vol_tower;

else
   Coning_height=Diff_height;
    Vol_cone= 1/3 * pi * Coning_height * (r^2+r*R+R^2);
    Total_Volume= Vol_cone+Vol_SPAR;
end

fprintf('Theoratical Total submerged volume is....(cu.m)',Total_Volume);

Diff_Volume=Total_Volume-OF_Volume;

fprintf('Difference in  Total submerged volume in foamstar is....(cu.m)',Diff_Volume);

Diff_draft=(Diff_Volume/(pi/4 * D_tower^2))/100;

fprintf('Difference in draft in Tower is....(cm)',Diff_draft);



