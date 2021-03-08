%% Setup
X = zeros(6,1); % platform position
XD = zeros(6,1); % platform velocity
N = 10; % number of coupling time steps
dt = 0.5;% coupling time step size (time between MoorDyn calls)
Ts = zeros(N,1); FairTens1 = zeros(N+1,1);% time step array

FLines_temp = zeros(1,6); % array for storing fairlead 1 tension time series

% going to make a pointer so LinesCalc can modify FLines
FLines_p = libpointer('doublePtr',FLines_temp);% access returned value with FLines_p.value

%%add path of library 
addpath=fullfile('/Users/sithikaliyar/Documents/MoorDyn-master/source/'); 
 
%% Initialization 
loadlibrary('Lines','MoorDyn'); % load MoorDyn DLL
calllib('Lines','LinesInit',X,XD) % initialize MoorDyn
%% Simulation 
XD(1) = 0.1; % give platform 0.1 m/s velocity in surge
 
for i=1:N
calllib('Lines', 'LinesCalc', X, XD, FLines_p, Ts(i), dt); % some MoorDyn time stepping
FairTens1(i+1) = calllib('Lines','GetFairTen',1); % store fairlead 1 tension
X = X + XD*dt; % update position
Ts(i+1) = dt*i; % store time
%% Ending 
calllib('Lines','LinesClose'); % close MoorDyn
unloadlibrary Lines; % unload library (never forget to do this!)
end

