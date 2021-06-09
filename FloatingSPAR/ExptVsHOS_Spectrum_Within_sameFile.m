%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ExptVsHOS_Spectrum_Within_sameFile(HOS_Filelocation,ExptIrr_Filelocation)

close all
clc
HOSfullfile=fullfile(HOS_Filelocation,'probes1.dat')
HOSdata=importdata(HOSfullfile);
pp_linear=HOSdata(:,2:end);

%% Expt File 
 load(ExptIrr_Filelocation)
 dt_expt=data.wave.time;
 pp_expt=data.wave.elevation;
   
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
[m,n]=size(pp_expt)
f_samp=100;
param=13;
%% Input general wave conditions
%t=input('Enter the Peak Time period for this case: ');  % in Seconds
t=1.72;
%hs=input('Enter the Peak Significant wave height for this case: '); % in Meter
hs=0.145;
%% Wave probe location and Time period
pp=[15 17 16.85 17 17.15 17.30 17.45 17.60];
cc=pp/(1.56*t);
cc_time=round(cc/(HOSdata(2,1)-HOSdata(1,1)));

%% Estimation begins
% fs=1/(HOSdata(2,1)-HOSdata(1,1));
% fs_expt=1/(dt_expt(2,1)-dt_expt(1,1));
% % skl=55;
% FigH = figure('Position', get(0, 'Screensize'));
% for i=1:n*2
% if (i>=n+1)
%     k=i-n;
%     Eta=pp_expt(cc_time(k):end,k);
% else
%     Eta=pp_linear(cc_time(i):end,i); %Reduce the calm time
% end
% 
% n_pt=length(Eta);
% 
% N_win=floor(f_samp*t*param); 
% % N_win=floor(n_pt/n_seg);
% [Pxx1,f_h1]=pwelch(Eta,hanning(N_win),floor(0.5*N_win),N_win,f_samp);
% % Pxx1_sm = smooth(Pxx1, movingAvgPt);
% 
% % [S2,W2]=HitSpek3(Eta_cut,n_pt,400,fs,skl); % 400 :hamming variabel, custom, can be modified
% 
% 
%  plot(f_h1,Pxx1,'LineWidth',3)
%  xlim([0 4])
%  hold on
%  H_m0_expt_welch1=4*sqrt(trapz(f_h1,Pxx1))
%  Diff_probe_1=((H_m0_expt_welch1-hs)/H_m0_expt_welch1)*100;
% end
% 
% %% Theoratical Spectrum- Chosen is Bretchneider spectrum or PM spectrum
% g=9.81;
% wo=(2*pi)/t;
% w=0:0.002:20; %frequency is the varying component
% n=length(w);
% for i=1:n
% y(i)=(-1.25)*((w(i)/wo)^(-4));
% a(i)=exp(y(i));
% b(i)=(wo^4)/((w(i))^5);
% s2(i)=0.3125*((hs^2)*a(i)*b(i));
% p2(i)=w(i);
% i=i+1;
% end
% s3=2*pi*s2;
% p3=p2/(2*pi);
% 
% plot(p3,s3,'k','LineWidth',3)
% ylabel('Spectral Density Function','FontSize',32)
% xlabel('Frequency','interpreter','latex','FontSize',32)
% set(gca,'Fontsize',32)
% grid on
% 
% % legend('WG1','WG2','WG3','WG4','WG5','WG6','WG7','WG8','Expt-WG1','Expt-WG2','Expt-WG3','Expt-WG4','Expt-WG5','Expt-WG6','Expt-WG7','Expt-WG8','Theoratical Spectrum')
% legend(['HOS WG'num2str(i)],['Expt-WG'num2str(i)],'Theoratical Spectrum')
% 
% hold off


%% Estimation begins
probe=1;

% skl=55;
FigH = figure('Position', get(0, 'Screensize'));
for i=probe

    plot(dt_expt,pp_expt(:,i),'LineWidth',3)
    hold on
    
    plot(HOSdata(:,1)-0.89,pp_linear(:,i),'LineWidth',3)
    xlim([0 300])
    ylabel('Surface Elevation ($\eta$) [m]','interpreter','latex','FontSize',32)
    xlabel('Time [s]','interpreter','latex','FontSize',32)
    set(gca,'Fontsize',32)
    title (['LC 3 - Probe WG',num2str(i)],'interpreter','latex','FontSize',32);
    legend ('Experiment','HOS ','interpreter','latex','FontSize',32);
    grid on;
 
end

FigH = figure('Position', get(0, 'Screensize'));
for k=probe

    Eta_expt=pp_expt(cc_time(k):end,k);
    dt_expt=dt_expt(cc_time(k):end,k);
    Eta_HOS=pp_linear(cc_time(k):end,k); %Reduce the calm time
    N_win=floor(f_samp*t*param); 
    [Pxx1,f_h1]=pwelch(Eta_expt,hanning(N_win),floor(0.5*N_win),N_win,f_samp);
    plot(f_h1,Pxx1,'LineWidth',3)
  
    hold on
    
    [Pxx1,f_h1]=pwelch(Eta_HOS,hanning(N_win),floor(0.5*N_win),N_win,f_samp);
    plot(f_h1,Pxx1,'LineWidth',3)
%   H_m0_expt_welch1=4*sqrt(trapz(f_h1,Pxx1))
%   Diff_probe_1=((H_m0_expt_welch1-hs)/H_m0_expt_welch1)*100;
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
    set(gca,'Fontsize',32)
    title (['LC 3 - Probe WG', num2str(k)],'interpreter','latex','FontSize',32);
    legend ('Experiment','HOS ','Target Spectrum','interpreter','latex','FontSize',32);
    xlim([0 3])
    grid on;
 
end
