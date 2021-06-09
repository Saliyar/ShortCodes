function [time, eta] = read_Draupner_data()
% read the data file 'wave1520.txt' provided by Sverre Haver
tmp = pwd;
%
%cd('D:\Bonnefoy\matlab\m-files\Draupner');
%
% Header of the file (5 lignes)
% "Wave Height"
% "Channel 110, WAVE_HT " 
% "01/01/95" "15:20:09"
% "Frequency   2.1333 Hz" 
% "m"
data = textread('wave1520.txt','',2560,'delimiter',' ','headerlines', 5);
data(:,1) = (data(:,1)-1) / 2.1333;
data(:,2)  = data(:,2);
% From S.H. e-mail: "The numbers are the distance from the sensor to the sea
% surface, i.e. in order to get a time history for the sea surface with
% origin at still water level and z upwards, you have to subtract the mean
% and multiply the numers by -1."
data(:,2) = - (data(:,2) - mean(data(:,2)));
%
if nargout == 0
    figure(999)
    plot(data(:,1), data(:,2), 'b')
    xlabel('Time in s.')
    ylabel('Elevation in m.')
else
    time = data(:,1);
    eta  = data(:,2);
end
%
cd(tmp);