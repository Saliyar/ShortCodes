%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function HOS_Spectrum_Within_sameFile(HOS_Filelocation)

close all
clc
HOSfullfile=fullfile(HOS_Filelocation,'probes1.dat')
data=importdata(HOSfullfile);
pp_linear=data(:,2:end);
%% Plot Wave probe from HOS files 
% FigH = figure('Position', get(0, 'Screensize'));
% newYlabels = {'Wave Elevation(x=2)','Wave Elevation(x=14)','Wave Elevation(x=16)'};
% s=stackedplot(data(:,1), pp_linear,'DisplayLabels' , newYlabels);
% s.LineWidth = 2;
% s.XLabel={'Time [s]'};
% s.FontSize = 25; 
% s.FontName='Arial';
% grid on;


% Number of probes 
[m,n]=size(data);
f_samp=100;
param=15;
%% Input general wave conditions
%t=input('Enter the Peak Time period for this case: ');  % in Seconds
t=1.72;
%hs=input('Enter the Peak Significant wave height for this case: '); % in Meter
hs=0.145;
%% Wave probe location and Time period
pp=[15 17 16.85 17 17.15 17.30 17.45 17.60];
cc=pp/(1.56*t);
cc_time=round(cc/(data(2,1)-data(1,1)));


%% Estimation begins
fs=1/(data(2,1)-data(1,1));
% skl=55;
FigH = figure('Position', get(0, 'Screensize'));
for i=2:n        
Eta_cut=data(cc_time(i-1):end,i); %Reduce the calm time 
n_pt=length(Eta_cut);
N_win=floor(f_samp*t*param); 
% N_win=floor(n_pt/n_seg);
[Pxx1,f_h1]=pwelch(Eta_cut,hanning(N_win),floor(0.5*N_win),N_win,f_samp);
% Pxx1_sm = smooth(Pxx1, movingAvgPt);

% [S2,W2]=HitSpek3(Eta_cut,n_pt,400,fs,skl); % 400 :hamming variabel, custom, can be modified


 plot(f_h1,Pxx1,'LineWidth',3)
 xlim([0 4])
 hold on
 H_m0_expt_welch1=4*sqrt(trapz(f_h1,Pxx1))
 Diff_probe_1=((H_m0_expt_welch1-hs)/H_m0_expt_welch1)*100;
end

%% Theoratical Spectrum- Chosen is Bretchneider spectrum or PM spectrum
g=9.81;
wo=(2*pi)/t;
w=0:0.002:20; %frequency is the varying component
n=length(w);
for i=1:n
y(i)=(-1.25)*((w(i)/wo)^(-4));
a(i)=exp(y(i));
b(i)=(wo^4)/((w(i))^5);
s2(i)=0.3125*((hs^2)*a(i)*b(i));
p2(i)=w(i);
i=i+1;
end
s3=2*pi*s2;
p3=p2/(2*pi);

plot(p3,s3,'k','LineWidth',3)
ylabel('Spectral Density Function','interpreter','latex','FontSize',32)
xlabel('Frequency','interpreter','latex','FontSize',32)
set(gca,'Fontsize',32)
grid on

legend('WG1','WG2','WG3','WG4','WG5','WG6','WG7','WG8','Theoratical Spectrum')
hold off

function [S,W]=HitSpek3(z,n,m,sfr,skl);
% HitSpek2 : generate wave spectrum from time signal
%
zf = fft(z);
R  = zf.*conj(zf)/n;
fr = (0:n-1)/n*sfr;
P  = 2*R/sfr;
w  = hamming(m) ;                
w  = w/sum(w) ;                  
w  = [w(ceil((m+1)/2):m);zeros(n-m,1);w(1:ceil((m+1)/2)-1)];  
w    = fft(w) ;                    
pavg = fft(P) ;                 
pavg = ifft(w.*pavg) ; 
S = abs(pavg(1:ceil(n/2)));
F = fr(1:ceil(n/2));
S=S/(2*pi)*sqrt(skl);% Spectral (m^2.s)
W=2*pi*F/sqrt(skl); % w (rad/s)