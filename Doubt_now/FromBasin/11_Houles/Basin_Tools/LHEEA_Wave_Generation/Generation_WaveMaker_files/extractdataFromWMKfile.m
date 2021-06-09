function [time, X, U] = extractdataFromWMKfile(filename, nheader)

%% Open the file
fid = fopen(filename);
%
nlines=0;
while ~feof(fid)
    fgets(fid);
    nlines = nlines+1;
end
nlines=nlines-nheader;
%
frewind(fid)
%
for i=1:nheader 
    fgets(fid);
end
%
data = fscanf(fid, '%f%*c%d %f%*c%d %f%*c%d\n',[6,nlines]);
%
time = data(1,:).*10.^data(2,:);
X    = data(3,:).*10.^data(4,:);
U    = data(5,:).*10.^data(6,:);
%
fclose(fid)



%
%problem for t>10000s
dt   = time(2)-time(1);
nt   = length(time);
time = 0:dt:(nt-1)*dt;
%
end