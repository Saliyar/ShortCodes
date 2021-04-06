function [Vec_filt,MOD,freq]=fft_LPRude(Vec_orig,Time_orig,f_cut)


pot2_si = 0;
% V=2*4*atan(1)
% t=1024
% X=10/(t)*[0:t-1];
% LNUM=size(X,2)
% Vec=(cos(V*X)+cos(3*V*X))

LNUM=length(Time_orig);
dt=Time_orig(2)-Time_orig(1);

Time=dt*(0:LNUM-1);

%tolto la media
Vec=Vec_orig(1:LNUM);%-mean(Vec_orig(1:LNUM));

%%%
if pot2_si==1    
LNUM=nextpow2(LNUM);
Time=dt*(0:LNUM-1);
end

FF=fft(Vec,LNUM);
% MSin=abs(FF)/LNUM*2;
% PSin=phase(FF);  %Very long to execute

df=1/Time(LNUM);
freq = (0:LNUM-1)*df;

aFFt=abs(FF)/LNUM*2;
aFFt(1)=aFFt(1)/2;

iFFt=angle(FF);

MOD=aFFt;
PHASE=iFFt;

figure(10);
plot(freq,aFFt)

nc = LNUM;
Ncut = round(f_cut/df)+1;
ncover2=floor(nc/2);
FF(Ncut+1:ncover2+1)   = 0+1i*0;
% FF(nc/2+2:nc-Ncut+2)= 0+i*0;
%%%%%%%%%%%%%%
FF(ncover2+2:nc-Ncut+1)= 0+1i*0;
%%%%%%%%%%%%%

Vec_filt=real(ifft(FF));

