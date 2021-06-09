function [time,probes,voltage ] = ReadFiles_QUANTUM_CATMAN_ASC_1(pathname, filename)




probes.filename = filename;
probes.pathname = pathname;
probes.fdata = filename;

fid = fopen ([probes.pathname probes.filename]);

% number of channels

channels = textscan(fid,'%s%f','HeaderLines',4);
Number_channels = channels{1,2}(1,1);
probes.n_probes = Number_channels-1;
frewind(fid);

%name probes
probes.name_probes = [];

while feof (fid) == 0

     tline = fgetl(fid);
        y1 = strmatch('Temps', tline);
        y2 = strmatch('fg', tline);
        
       
        index.name = y1;
        
            if y1~= 0

               C = strsplit(tline);
               C = C(7:end);
               CH = strmatch('CH', C);
               
             indexgood=1:length(C);
             indexgood(CH) = [];
              C= C(indexgood);
           
            probes.name_probes = (C);
           
              y1 = 0;

            end
     
end

fclose(fid);


%read the data

fid = fopen ([pathname filename]);

f = ' %f';

for j= 1:probes.n_probes 
    f = strcat(f,' %f');
end

trame = cellstr(f);

A = textscan(fid,trame{1},'delimiter',' ','HeaderLines',38); %% is that column number?


voltage.voltage_1 = cell2mat(A);

fclose(fid);

for n=1:length(probes.name_probes) % all channels including the time channels
      
    strr= cleanString(probes.name_probes{n},{'-', ' '});
   
    eval(['probes.II_' strr  ' = n ']);
    % index {n,1} is here to build a column vector (one column with one
    % channel on each line)
end


[a b] = size(voltage.voltage_1);

probes.n_pts = a;

 
%create time vector


time = voltage.voltage_1(:,1) - voltage.voltage_1(1,1);
probes.f_samp = 1/(time(2,1)-time(1,1));


%name probes

probes.data_timing = probes.n_pts/probes.f_samp;
voltage.voltage_1 = (voltage.voltage_1(:,2:probes.n_probes+1));
probes.n_zero = 0;
probes.z_timing=0;




