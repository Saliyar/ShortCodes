function [dt_stream,Eta_stream]= CallingCNStreamOutput(numberofPeaks)

data=load('/home/saliyar/Documents/Working/CN_Stream_master/output/FreeSurface_CN_Stream1.dat');
x=data(:,1);
Eta=data(:,2);
n=numberofPeaks;
deltax=x(2)-x(1);
Eta1=repmat(Eta,n,1);
k=length(x);
% 
for i=1:n-1
    for j=1:k
    x(k*i+j)=x(end)+deltax;
    end
end
dt_stream=x;
Eta_stream=Eta1;