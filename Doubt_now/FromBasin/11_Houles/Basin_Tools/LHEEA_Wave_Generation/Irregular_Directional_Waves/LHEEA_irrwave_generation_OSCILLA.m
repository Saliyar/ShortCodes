function LHEEA_irrwave_generation_OSCILLA
% irregular waves
% mean direction
% spreading
% Dalrymple method

addpath ../lib
warning('off', 'convert2nondim:allready')

% Should be better to define spectrum objects...
global spectra_names
spectra_names.jonswap = {'JONSWAP', 'jonswap', 'Jonswap'};
spectra_names.bretsch = {'bretsch', 'Bretschneider', 'bretschneider'};
spectra_names.error   = ': Unknown spectrum. Check spelling and spectra_names variables';

check_wavemaker_motion_speed = 0;
export_2_HOS = 0;

%% Parameters
wave_basin = 'ECN_wave'; % among 'ECN_wave', 'ECN_towing', or 'ECN_small'
% Repeat period
rnum = 14; % with corresponding repeat period 12=128s, 14=512s, 15=1024s, 16=2048s, 17=4096s
T_repeat = pow2(rnum-5);
%% .wav file
file_name   = 'MARINET2_LHEEA_OSCILLA_Irreg_V1'; % name of the .wav file
file_header = 'Irregular waves for MARINET2/ECN-LHEEA/OSCILLA campaign'; % will appear in the client.exe windows
file_path  = 'ocean\'; % path relative to the current routine's path where the .wav file will be stored
%% Frequency spectrum
% All parameters at model scale
% Significant wave height
H_s = [75, 75, 175, 175, 175, 375, 480, 125, 225]/1000; % in m
% Wave period at the peak of the spectrum
T_p = [1.4, 3.3, 1.7, 3.0, 4.3, 2.7, 2.5, 1.7, 3.6]; % in s
% Type of spectrum (see global variable spectra_names for available types)
spectrum = cell(size(T_p));
for m=1:length(T_p), spectrum{m} = 'Bretschneider'; end
% Peakedness parameter for Jonswap spectrum
gamma = 3.3 * ones(size(T_p));
%% Directionality
% Mean direction
direction_mean = 0 * ones(size(T_p)); % in degrees / constant wave heading, use: = 20 * ones(size(T_p)); / houle droite, use = zeros(size(T_p));
% Spreading (cos^2s(theta/2) only
spreading = cell(size(T_p));
for m=1:length(T_p), spreading{m} = 'cosn'; end
s = Inf * ones(size(T_p)); % use Inf for uni-directional waves
s(end-1:end) = 10;
%
%% Phase sets
phase_set = ones(size(T_p));
phase_set(end-2) = 3;
% Replicate 
N_spectrum = length(H_s);
index = [];
for n=1:N_spectrum
    index = [index, n*ones(1,phase_set(n))];
end
%

%% Wavemaker parameters
% parameters for Dalrymple method (2 parameters)
X_d = 17; % in m, target distance
law = 'Dalrymple';
%% Wavemaker correction
multiplier_linear = 1.07 * ones(size(T_p)); % linear wavemaker transfer function correction (gain)
multiplier_nonlinear = 1.0 * ones(size(T_p)); % nonlinear wavemaker transfer function  (induced by steepness)
% wavemaker
wmk = wavemaker(wave_basin);
depth = get(wmk,'depth');
% output preparation
ocean_prepare_folder(file_path);
routine = mfilename;
%
switch wave_basin
    case 'ECN_wave'
        ttf_file = 'nantes_main_posn/default.ttf';
    case 'ECN_towing'
        ttf_file = 'nantes_towing/default.ttf';
    case 'ECN_small'
        ttf_file = 'nantes_twin/Twin_h094.ttf';
end
fid = ocean_write_header([file_path, '\', file_name], file_header, routine, ttf_file);
fid_sum = ocean_write_summary_header([file_path, '\', file_name], file_header, routine, ttf_file);
%
%% Wave data
N_spectra = length(index);
for n=1:N_spectra
    % frequency range
    freq_range = [0,2];
    % harmonic object
    harmo = floor(freq_range*T_repeat); % # of the wave fronts in ocean langage (frequency is harmo/T_repeat)
    harmo = harmo(1):harmo(2);
    % remove null frequency
    harmo(harmo == 0) = [];
    % build amplitude spectrum from energy spectrum parameters
    [harmo, ampli] = LHEEA_build_ampli(1, harmo, T_repeat, H_s(index(n)), T_p(index(n)), spectrum{index(n)}, gamma(index(n)));
    direction = LHEEA_build_direction(1, harmo, direction_mean(index(n)), spreading{index(n)}, s(index(n)));
    % 
    phase = 2*pi*rand(size(harmo));
    harmo = harmonic(harmo, ampli, phase, direction);
    % wavemaker control law
    if s(index(n)) == Inf && direction_mean(index(n)) == 0
        c_law = control_law(0, 'snake');
    else % Dalrymple method for spread seas and/or oblique seas
        c_law = control_law(0, law, X_d, 1);
    end
    % wave object
    wv = wave(T_repeat, 8, harmo, wmk, c_law);
    if check_wavemaker_motion_speed
        % check the wavemaker motion
        LHEEA_check_wavemaker(wv)
    end
    % correcting transfer function = nonlinear effects
    % before exporting to HOS
    wv = multiplier_nonlinear(index(n)) * wv;
    if export_2_HOS
        % export for HOS
        export(wv, 'cfgdat', fullfile(file_path,'data',strcat(file_name, '_HOS', '_', num2str(n))));
    end
    % correcting transfer function (gain) = wrong transfer function
    % specific to experimental wavemaker so after exporting to HOS
    wv = multiplier_linear(index(n)) * wv;
    % exporting to files
    file_n = fullfile('data',strcat(file_name, '_', num2str(n)));
    % ocean 2000 components per file rule
    ocean_write_summary_data(fid_sum, n, wv)
    N_2000 = export(wv, 'ocean', fullfile(file_path,file_n));
    % data text
    ocean_write_data_read(fid, file_n, n, N_2000)
end
%%
fprintf(fid,'/* End of wave data */\n');
fprintf(fid,'\n');
fprintf(fid,'begin\n');
%% writing runs
for m=1:N_spectra
    run = build_run_title(m, spectrum{index(m)}, H_s(index(m)), T_p(index(m)), gamma(index(m)), direction_mean(index(m)), spreading{index(m)}, s(index(m)));
    ocean_write_run(fid, run, rnum, m)
end
fprintf(fid,'end;\n');
fclose(fid);
fclose(fid_sum);

rmpath ../lib

function run = build_run_title(m, spectrum, H_s, T_p, gamma, direction, spreading, s)
global spectra_names
if any(strcmp(spectrum, spectra_names.jonswap)) && nargin < 5
    error('Missing gamma')
end
if nargin < 8
    s = Inf;
end
    
switch spectrum
    case spectra_names.jonswap
        run = ['Run', num2str(m), ', JONSWAP, Tp=', num2str(T_p,3), 's, Hs=', num2str(H_s,3), 'm, gamma=', num2str(gamma)];
    case spectra_names.bretsch
        run = ['Run', num2str(m), ', Bretsch, Tp=', num2str(T_p,3), 's, Hs=', num2str(H_s,3), 'm'];
    otherwise
        error([spectrum, spectra_names.error])
end
run = [run, ', dir=', num2str(direction), 'deg'];
if s ~= Inf
    run = [run, ', ', spreading, ', s=', num2str(s)];
end

