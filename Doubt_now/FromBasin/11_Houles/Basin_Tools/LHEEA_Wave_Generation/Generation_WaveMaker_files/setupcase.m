function [filename,labelWave,refTime, refPosition, duration, scale, shift_phase,x_shift, window, foc_loc, filename_export]  = setupcase(iCase,scale, path_base)

%%%%%%%%%%%%%%% CASE GOM 1000 YR RP benchmark Wave 1

switch iCase
    case 11
        labell='GOM_1000RP';
Path_base       = 'D:\ownCloudData\Chaire CN-BV NOT SHARED\WP Non Linear Long Sea States\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'data_simulations\HOS-NWT\Unidirectional_3h_Hs_18p5\N2048_BM0p70_alpha0p02\';
irun = 4;
pathRun = [Path_base  WhereAreTheruns 'Run' num2str(irun) '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave1';

refTime     = 1550; % Time of the event at full scale (sec?)

duration    = 30*60; % duration at full scale
refPosition = 2094;
foc_loc = refPosition/scale;
%foc_loc = 19.313+(20.94-20.81); %define the focusing location: probe number 17 with shift so that it corresponds to pivot position without shift...

x_shift = -0;
%% Restrict the time to the window we are interested in...
window = refTime + [-duration/2 duration/2];

    case 12
labell='GOM_1000RP';
Path_base       = 'D:\ownCloudData\Chaire CN-BV NOT SHARED\WP Non Linear Long Sea States\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'data_simulations\HOS-NWT\Unidirectional_3h_Hs_18p5\N2048_BM0p70_alpha0p02\';
irun = 4;
pathRun = [Path_base  WhereAreTheruns 'Run' num2str(irun) '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave2';

refTime     = 2450; % Time of the event at full scale (sec?)
duration    = 30*60; % duration at full scale      

refPosition = 2094;
foc_loc = refPosition/scale;
%foc_loc = 19.313+(20.94-20.81); %define the focusing location: probe number 17 with shift so that it corresponds to pivot position without shift...

x_shift = 0;
%% Restrict the time to the window we are interested in...
window = refTime + [-duration/2 duration/2];     

    case 13
     labell='GOM_1000RP';
Path_base       = 'D:\ownCloudData\Chaire CN-BV NOT SHARED\WP Non Linear Long Sea States\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'data_simulations\HOS-NWT\Unidirectional_3h_Hs_18p5\N2048_BM0p70_alpha0p02\';
irun = 4;
pathRun = [Path_base  WhereAreTheruns 'Run' num2str(irun) '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave3';

refTime     = 6000; % Time of the event at full scale (sec?)
duration    = 30*60; % duration at full scale     
        
%foc_loc = 19.313+(20.94-20.81); %define the focusing location: probe number 17 with shift so that it corresponds to pivot position without shift...
refPosition = 2094;
foc_loc = refPosition/scale;
x_shift = 0  
%% Restrict the time to the window we are interested in...
window = refTime + [-duration/2 duration/2];

    case 21

        labell='GOM_1000RP_shift';
Path_base       = 'D:\ownCloudData\Chaire CN-BV NOT SHARED\WP Non Linear Long Sea States\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'data_simulations\HOS-NWT\Unidirectional_3h_Hs_18p5\N2048_BM0p70_alpha0p02\';
irun = 4;
pathRun = [Path_base  WhereAreTheruns 'Run' num2str(irun) '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave1';

refTime     = 1550; % Time of the event at full scale (sec?)
refPosition = 749.5800; % location of the extreme event
duration    = 30*60; % duration at full scale

%foc_loc = 19.313+(20.94-20.81); %define the focusing location: probe number 17 with shift so that it corresponds to pivot position without shift...
foc_loc = 14; %for no shift on position
x_shift = -(refPosition/scale-foc_loc);
%% Restrict the time to the window we are interested in...
window = refTime + [-duration/2 duration/2];
        

    case 31

        labell='GOM_1000RP_shift22';
Path_base       = 'D:\ownCloudData\Chaire CN-BV NOT SHARED\WP Non Linear Long Sea States\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'data_simulations\HOS-NWT\Unidirectional_3h_Hs_18p5\N2048_BM0p70_alpha0p02\';
irun = 4;
pathRun = [Path_base  WhereAreTheruns 'Run' num2str(irun) '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave1';

refTime     = 1550; % Time of the event at full scale (sec?)
refPosition = 749.5800; % location of the extreme event
duration    = 30*60; % duration at full scale

%foc_loc = 19.313+(20.94-20.81); %define the focusing location: probe number 17 with shift so that it corresponds to pivot position without shift...
foc_loc = 22; %for no shift on position
x_shift = -(refPosition/scale-foc_loc);
%% Restrict the time to the window we are interested in...
window = refTime + [-duration/2 duration/2];




    case 111       
       labell='ITTC_SS6_Hs6';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave1';

refTime     = 4500+900; % Time of the event at full scale (sec?)

duration    = 30*60; % duration at full scale       
refPosition = 233.836565683068 * 2;
foc_loc = refPosition/scale;

deltaBeforeEvent = 5 * 60;
x_shift = 0
%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];


    case 112       
       labell='ITTC_SS6_Hs6';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave2';

refTime     = 6880+900; % Time of the event at full scale (sec?)

duration    = 30*60; % duration at full scale       
deltaBeforeEvent = 5 * 60;
refPosition = 233.836565683068 * 2;
foc_loc = refPosition/scale;
x_shift =0
%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];


    case 113       
       labell='ITTC_SS6_Hs6';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave3';

refTime     = 9440+900; % Time of the event at full scale (sec?)
refPosition = 233.836565683068 * 2;
foc_loc = refPosition/scale;
duration    = 30*60; % duration at full scale       
deltaBeforeEvent = 5 * 60;

x_shift =0
%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];



  case 121       
       labell='ITTC_SS6_Hs6_shift14';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave1';

refTime     = 4500+900; % Time of the event at full scale (sec?)

duration    = 30*60; % duration at full scale       
refPosition = 233.836565683068 * 7;
foc_loc = 14;
x_shift = -(refPosition/scale-foc_loc);
deltaBeforeEvent = 5 * 60;

%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];


    case 122       
       labell='ITTC_SS6_Hs6_shift14';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave2';

refTime     = 6880+900; % Time of the event at full scale (sec?)
refPosition = 233.836565683068 * 7;
foc_loc = 14;
x_shift = -(refPosition/scale-foc_loc);
duration    = 30*60; % duration at full scale       
deltaBeforeEvent = 5 * 60;

%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];


    case 123       
       labell='ITTC_SS6_Hs6_shift14';
Path_base       = 'D:\ownCloudData\Project_ReferenceWave\';
%WhereAreTheruns = 'data_simulations/HOS-NWT/Unidirectional_3h_Hs17/New_config_0p5fmax/N2048_BM0p70_alpha0p02/';
WhereAreTheruns = 'SeaState6\23.HOSNWT_nX513_nAdd65_mHOS7\';

pathRun = [Path_base WhereAreTheruns '\Results'];

filename = 'wmk_motion.dat';
filename = fullfile(pathRun,filename);
labelWave ='Bench_Wave3';

refTime     = 9440+900; % Time of the event at full scale (sec?)
refPosition = 233.836565683068 * 7;
foc_loc = 14;
x_shift = -(refPosition/scale-foc_loc);
duration    = 30*60; % duration at full scale       
deltaBeforeEvent = 5 * 60;

%% Restrict the time to the window we are interested in...
window = refTime - deltaBeforeEvent + [0 duration];


end

%%%%%%%%%%




shift_phase = 0;


%%%%%%%%%%%

filename_export = [path_base labell 'Results\' num2str(scale) '\' labell '_' labelWave '_scale_' num2str(scale,3)];
