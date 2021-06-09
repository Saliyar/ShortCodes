function LHEEA_irrwave_generation_MAIN
% This program is the template program for irregular wave generation at LHEEA
% It should be copied and modified to the campaign's need
% It includes Dalrymple method for oblique wave generation, directional
% spreading, mean direction, several phase sets
%
% See also EXAMPLE_build_waves.m for regular oblique wave generation
% 

rmpath('C:\Program Files\MATLAB\R2016a\toolbox\symbolic\symbolic'); % Use in case of prob with harmonic
rmpath('C:\Program Files\MATLAB\R2018b\toolbox\symbolic\symbolic');

global spectra_names spreading_names
spectra_names.jonswap = {'JONSWAP', 'jonswap', 'Jonswap'};
spectra_names.bretsch = {'bretsch', 'Bretschneider', 'bretschneider'};
spectra_names.error   = ': Unknown spectrum. Check spelling and spectra_names variable';
spreading_names.uni = {'1D', 'uni', 'mono', 'uni-directional', 'uni-directionnel', 'mono-directional', 'mono-directionnel'};
spreading_names.cos_n = {'coss', 'cosn', 'cos_n', 'cos_s'};
spreading_names.cos_2n = {'cos2s', 'cos2n'};
spreading_names.error   = ': Unknown spreading. Check spelling and spreading_names variable';

check_wavemaker_motion_speed = 0;
export_2_HOS = 1;

%% Parameters to be modified
wave_basin = 'ECN_wave'; % among 'ECN_wave'=deep-water tank (DWT), 'ECN_towing'=towing tank, or 'ECN_small'=finite-depth tank
% Repeat period 
rnum = 14; % with corresponding repeat period 12=128s, 14=512s, 15=1024s, 16=2048s, 17=4096s
T_repeat = pow2(rnum-5);
%% .wav file 
file_name   = 'test'; % name of the .wav file
file_header = 'Irregular waves for ECN campaigns'; % will appear in the client.exe windows
Project_name = 'MARINET2_Mocean';
file_path  = [Project_name,'\']; % path relative to the current routine's path where the .wav file will be stored

%% Frequency spectrum
% Significant wave height
H_s = [31.2 45 61.2 79.9 101.2 124.9 151.1 179.9 211.1 244.8]/1000; % in m
H_s = [H_s H_s/2];
% Wave period at the peak of the spectrum
T_p = 1:0.2:2.8; % in s
T_p = [T_p T_p];
% Type of spectrum (see global variable spectra_names for available types)
spectrum = cell(size(T_p));
for m=1:length(T_p), spectrum{m} = 'Bretschneider'; end
% Peakedness parameter for Jonswap spectrum
gamma = 3.3 * ones(size(T_p));

%% Number of phase sets for each run
phase_set = ones(size(T_p));
phase_set(end-2) = 3;
% Target location
target_location = 60; % m (put zero if not relevant)
%
%% Directionality
% Mean direction
direction_mean = 0 * ones(size(T_p)); % in degrees / constant wave heading, use: = 20 * ones(size(T_p)); / houle droite, use = zeros(size(T_p));
% Spreading type
spreading = cell(size(T_p));
for m=1:length(T_p), spreading{m} = 'uni'; end % 'uni' for uni-directional waves, see global variable spreading_names
% Spreading parameter
s = Inf * ones(size(T_p)); % unused for uni-directional waves

%% Wavemaker parameters
% parameters for Dalrymple method (3 parameters) (
X_d = 17; % in m, target distance
law = 'Dalrymple';
paddles = 0;
%% Wavemaker correction
% linear wavemaker transfer function correction (gain)
multiplier_linear = 1.0 * ones(size(T_p)); % default = no correction, could be adjusted run by run
if strcmp(wave_basin, 'ECN_wave') % default transfer function is too low in the Deep Water Tank, Large Wave Basin
    multiplier_linear = 1.07 * ones(size(T_p)); % linear wavemaker transfer function correction (gain)
end
% nonlinear wavemaker transfer function  (induced by steepness)
multiplier_nonlinear = 1.0 * ones(size(T_p)); % default = no correction, could be adjusted run by run
% wavemaker
wmk = wavemaker(wave_basin);
depth = get(wmk,'depth');
%% we will further replicate parameters when several phase sets are required
% the vector index contains 
N_spectrum = length(H_s);
index = [];
phase_number = [];
for n=1:N_spectrum
    index = [index, n*ones(1,phase_set(n))];
    phase_number = [phase_number, 1:phase_set(n)];
end
%% output preparation
LHEEA_create_directory(file_path);
routine = mfilename;
%% Transfer function name in the .wav file
switch wave_basin
    case 'ECN_wave'
        ttf_file = 'nantes_main_posn/default.ttf';
    case 'ECN_towing'
        ttf_file = 'nantes_towing/towing_h2p9_v3.ttf';
    case 'ECN_small'
        ttf_file = 'nantes_twin/Twin_h094.ttf';
end
%% Writing headers
fid = ocean_write_header([file_path, '\', file_name], file_header, routine, ttf_file);
fid_sum = ocean_write_summary_header([file_path, '\', file_name], file_header, routine, ttf_file);
%
%% Wave data
N_spectra = length(index);
for m=1:N_spectra
    % m= index taking into account the phase sets.
    % n=index of data in H_s, T_p, ... arrays
    n = index(m);
    % frequency range
    freq_range = [0,2]; % Hz
    % harmonic object
    harmo = floor(freq_range*T_repeat); % # of the wave fronts in ocean langage (frequency is harmo/T_repeat)
    harmo = harmo(1):harmo(2);
    % remove null frequency
    harmo(harmo == 0) = [];
    % build amplitude spectrum from energy spectrum parameters
    [harmo, ampli] = LHEEA_build_ampli(1, harmo, T_repeat, H_s(n), T_p(n), spectrum{n}, gamma(n));
    direction = LHEEA_build_direction(1, harmo, direction_mean(n), spreading{n}, s(n), m);
    % we want to make sure we can regenerate the same phases so we specify
    % the random seed for each run
    rng(m, 'twister'); % specify the seed and the type of the random number generator
    % Random phases
    phase = 2*pi*rand(size(harmo));
    % use target location generation (1D correct)
    [t_arrival, harmo, ampli, phase] = LHEEA_delayed_generation(harmo, ampli, phase, T_repeat, depth, target_location);
    disp(['Arrival time = ', num2str(t_arrival,3), ' s and T_repeat = ', num2str(T_repeat), ' s'])
    % number of zero-crossing waves (T_Z ~ T_p/1.4)
    N_waves = floor((T_repeat-t_arrival)/(T_p(n)/1.4)/10)*10;
    disp(['Number of zero-crossing waves = ', num2str(N_waves,3)])
    if N_waves < 100
        warning('Expected number of waves seems limited within T_repeat. You may want to think about increasing T_repeat')
    end
    % constructing harmonic object
    harmo = harmonic(harmo, ampli, phase, direction);
    % wavemaker control law
    if s(n) == Inf && direction_mean(n) == 0
        c_law = control_law(paddles, 'snake');
    else % Dalrymple method for spread seas and/or oblique seas
        c_law = control_law(paddles, law, X_d, 1);
    end
    % wave object
    wv = wave(T_repeat, 8, harmo, wmk, c_law);
    if check_wavemaker_motion_speed
        % check the wavemaker motion
        LHEEA_check_wavemaker(wv)
    end
    % correcting transfer function = nonlinear effects
    % before exporting to HOS
    wv = multiplier_nonlinear(n) * wv;
    if export_2_HOS
        % export for HOS
        export(wv, 'cfgdat', fullfile(file_path,'data',strcat(file_name, '_HOS', '_', num2str(m))));
    end
    % correcting transfer function (gain) = wrong transfer function
    % specific to experimental wavemaker so after exporting to HOS
    wv = multiplier_linear(n) * wv;
    % exporting to files
    file_m = fullfile('data',strcat(file_name, '_', num2str(m)));
    % ocean 2000 components per file rule
    ocean_write_summary_data(fid_sum, m, wv)
    N_2000 = export(wv, 'ocean', fullfile(file_path,file_m));
    % data text
    ocean_write_data_read(fid, file_m, m, N_2000)
end
%%
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
%% writing runs
for m=1:N_spectra
    n = index(m);
    run = build_run_title(m, spectrum{n}, H_s(n), T_p(n), gamma(n), direction_mean(n), spreading{n}, s(n), phase_number(m));
    ocean_write_run(fid, run, rnum, m)
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);


function run = build_run_title(m, spectrum, H_s, T_p, gamma, direction, spreading, s, phase)
global spectra_names
if any(strcmp(spectrum, spectra_names.jonswap)) && nargin < 5
    error('Missing gamma')
end
if nargin < 6
    s = Inf;
end
    
switch spectrum
    case spectra_names.jonswap
        run = ['Run', num2str(m), ', JSWP, Tp=', num2str(T_p,3), 's, Hs=', num2str(H_s,3), 'm, gam.=', num2str(gamma)];
    case spectra_names.bretsch
        run = ['Run', num2str(m), ', Bret, Tp=', num2str(T_p,3), 's, Hs=', num2str(H_s,3), 'm'];
    otherwise
        error([spectrum, spectra_names.error])
end
run = [run, ', ph=', num2str(phase, '%02d')];
if direction ~= 0
    run = [run, ', dir=', num2str(direction), 'deg'];
end
if s ~= Inf
    run = [run, ', ', spreading, ', s=', num2str(s)];
end
