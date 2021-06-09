function [time, probes, voltage_1]   = ReadFiles_qualisys_motions(pathname, filename)


probes.filename = filename;
probes.pathname = pathname;
probes.fdata = filename;

% find  data in the analogue file
fid = fopen ([pathname filename]);


probes.n_probes = 18;
formatt= '%f %f ';
for i=1: probes.n_probes
    formatt = [formatt '%f '];
end
formatt = [formatt '%*[^\n]'];

B = textscan(fid,formatt,'HeaderLines',11 );
voltage_1 = cell2mat(B);


fclose(fid);

time = voltage_1(:,2);

voltage_1 = voltage_1(:,3:probes.n_probes);
probes.n_pts = length(voltage_1);


% find  data in the motions file
fid = fopen ([pathname filename]);

%frequency
F =  textscan(fid,'%s %s [^\n]','HeaderLines',3);
F = cell2mat( F{2});
probes.f_samp = str2double (F);

%name

name = textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s [^\n]','HeaderLines',7);

for i = 4:probes.n_probes+1
    probes.name_probes(1,i-3) = name{i};
    
    strr= cleanString(char(name{i}),{'-', ' ','[',']'});
    
    eval(['probes.II_' strr  ' = i-3 ;']);
end

fclose(fid);

probes.data_timing = probes.n_pts/probes.f_samp;
probes.n_zero = 0;
probes.z_timing = 0;
probes.remove_offset = 0;
end

