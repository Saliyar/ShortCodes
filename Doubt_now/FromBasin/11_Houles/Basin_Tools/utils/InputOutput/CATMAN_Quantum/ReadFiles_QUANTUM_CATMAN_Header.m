function [time,probes,voltage ] = ReadFiles_QUANTUM_CATMAN_Header(pathname, filename)



file_mat = load ([pathname filename]);

%number of channels
probes.n_channels = str2double(file_mat.File_Header.NumberOfChannels); % including one time channel per Quantum module
probes.n_pts = str2double(file_mat.File_Header.NumberOfSamplesPerChannel);

%name channels
probes.name_channels = cell(probes.n_channels,1);
for n=1:probes.n_channels % all channels including the time channels
    probes.name_channels{n}= eval(['file_mat.Channel_', num2str(n), '_Header.SignalName;']);
    
    strr= cleanString(probes.name_channels{n},{'-', ' '});
   
    eval(['probes.II_' strr  ' = n ;']);
    % index {n,1} is here to build a column vector (one column with one
    % channel on each line)
end
%index of the channels containing 'Temps__' in channel name
% time channel names are "Temps__1_-_Vitesse_de_mesure_standard", 2,3,4...
% index_time = find(contains(probes.name_channels, 'Temps_'));
% index of probes
index_probes = 1:probes.n_channels; % all channels: need to remove the time channels
% index_probes(index_time) = []; % remove time channels

%obtain time vector from first module
%don't channels named Temps__2_-_Vitesse_de_mesure_standard ,3,4 because
%it's the same than Temps__1_-_Vitesse_de_mesure_standard
%same sampling frequency on the four modules

time = eval(['file_mat.Channel_', num2str(probes.II_Temps__1__Vitesse_de_mesure_standard), '_Data;']);

%name probes
probes.n_probes = length(index_probes);
voltage_1 = zeros(probes.n_pts, probes.n_probes);
for n=1:probes.n_probes
    index = index_probes(n);
    
   
    probes.name_probes{n,1}= eval(['file_mat.Channel_', num2str(index), '_Header.SignalName;']);
    % index {n,1} is here to build a column vector (one column with one
    % channel on each line)
    voltage_1(:,n) = eval(['file_mat.Channel_', num2str(index), '_Data;']);
end

probes.f_samp = file_mat.File_Header.SampleFrequency;
probes.f_samp = strrep(probes.f_samp,',','.');
%probes.f_samp(findstr(probes.f_samp, ',')) = '.';
probes.f_samp = str2double(probes.f_samp);

%name probes
probes.data_timing = probes.n_pts/probes.f_samp;
voltage.voltage_1 = voltage_1;
probes.n_zero = 0;
probes.z_timing=0;


end

