function data = Expe_Time_Reversal_read(PathName,FileName,n_probes,display)
%
% Read the Logger data in the file
% and pre-process the data
%
if nargin <4
    display = 1;
end
if nargin <3
    n_probes = 15;
end
if nargin < 2
    PathName = '.';
    cd(PathName)
    % Choose the data file you want to process
    [FileName, PathName] = uigetfile(fullfile(PathName,'*.dat'), 'Logger data file');
    [tmp, FileName] = fileparts(FileName);
end
%
% Load the data and pre-process (conversion to physical values
data = read_Logger_data(fullfile(PathName, [FileName,'.dat']),n_probes,display);
%
%% Calibration coefficients
% Wave Probes
gain_probes = [37.8, 37.1, 37.0, 37.5, 37.6, 37.3, 37.2, ...
    36.8, 36.0, 36.2, 36.6, 36.1, 36.1, 36.1]; % mm/V
% Wavemaker
gain_wmk = 76.4; % mm/V
%
% Wave Probes
data.wave = ones(data.n_pts,1)*gain_probes .* data.wave/1000;
%% Wavemaker
if (n_probes == 15)
    data.wmk = gain_wmk .* data.wmk/1000;
end
%
% Display
if (display == 1)
    figure(2),clf
    % ax(1) = subplot(4,1,1);
    % plot(data.time, data.wmk)
    % ylabel('Wavemaker in mm')
    ax(1) = subplot(3,1,1)
    plot(data.time, data.wave(:,1:5)*1000)
    legend('wp_1','wp_2','wp_3','wp_4','wp_5')
    ylabel('WP in mm')
    grid on
    ax(2) = subplot(3,1,2);
    plot(data.time, data.wave(:,6:10)*1000)
    legend('wp_6','wp_7','wp_8','wp_9','wp_1_0')
    ylabel('WP in mm')
    ax(3) = subplot(3,1,3);
    plot(data.time, data.wave(:,11:14)*1000)
    legend('wp_1_1','wp_1_2','wp_1_3','wp_1_4')
    ylabel('WP in mm')
    xlabel('Time in s')
    grid on
    linkaxes(ax, 'x')
end
%

function data = read_Logger_data(file,n_probes,display)
%
fid = fopen(file);
%
% acquisition
header = textscan(fid, '%s\t%s\t%f\t%d\t%f\t%f\t%f\n','HeaderLines',6);
data.f_samp      =   header{3};
data.zero_length =   header{5};
n_zero           = data.f_samp*data.zero_length;
%
% %n_probes = 14;
% n_probes = 15;
% zeros
offset.voltage = find_data(fid, 'ZEROS::');
offset.voltage = reshape(offset.voltage, [n_probes+1, n_zero]).';
offset.time    = offset.voltage(:,1);
offset.voltage = offset.voltage(:,2:n_probes+1);
% data
data.voltage        = find_data(fid, 'DATA::');
data.n_pts = floor(length(data.voltage) / (n_probes+1));
data.voltage = reshape(data.voltage, [n_probes+1, data.n_pts]).';
data.time    = data.voltage(:,1);
data.voltage = data.voltage(:,2:n_probes+1);
%
% signal offset
ind = 1:n_probes;
offset.mean    = mean(offset.voltage(:,ind), 1);
data.voltage(:,ind) = data.voltage(:,ind) - ones(data.n_pts,1) * offset.mean;
% Display
if (display == 1)
    figure(1), clf
    ax(1) = subplot(2,1,1);
    plot(data.time, data.voltage)
    ylabel('Analog signals in V')
    grid on

    % Display
    ax(2) = subplot(2,1,2);
    plot(data.time, data.voltage)
    ylabel('Analog signals in V')
    xlabel('Time in s')
    grid on
    linkaxes(ax, 'x')
end

% Wave Probes
data.wave = data.voltage(:,1:14);
%% Wavemaker
if (n_probes == 15)
    data.wmk = data.voltage(:,15);
end
%
function y = find_data(fid, keyword)
%
while feof (fid) == 0
    tline = fgets(fid);
    test = strmatch(keyword, tline);
    if test ~= 0
        y = fscanf(fid,'%f');
    end
end
%
frewind(fid);
