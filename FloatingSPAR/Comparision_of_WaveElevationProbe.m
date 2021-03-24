%% Comparision of WaveProbes in the domain
% Number of wave probes are palced in the line shown in the Figure below (Distance 
% between the probes were kept as 0.01). 
% 
% Simulation is type is of Free Decay!! So Expect a circular wave of same aplitude 
% and phase should reach the end and get settled in Relaxation zone!! 
% 
% `                            
% 
% 
% 
% This code will compare the Wave probes propagation in both the directions 
% ! Both the probes line are in the same file 
% Read the data

clc
close all
clear

%% Load foamStar focussing wave probe details 
data1=load(['/mnt/data2/saliyar/Spece_constraint/Files_from_LIGER/Floating_Body_Simulation/Revision1/FreeDecay/HeaveFD/Heave_ppcd35_Rev1/postProcessing/waveProbe/0/surfaceElevation1.dat']);
dt_foamStar1=data1(:,1);
Eta_foamStar1=data1(:,2:end);
%% Find the wave probe location of Second line

Waveprobe2= 123; % p0223


%% Plot the Wave Probe


surfaceElevation1=Eta_foamStar1(:,1:Waveprobe2-1);
surfaceElevation2=Eta_foamStar1(:,1:Waveprobe2);

[row1,col1]=size(surfaceElevation1);
[row2,col2]=size(surfaceElevation2);
Fs=1/(dt_foamStar1(2)-dt_foamStar1(1));


FigH = figure('Position', get(0, 'Screensize'));

for i=6500:row1
    i
   subplot(3,1,1)
   plot(1:col1,surfaceElevation1(i,:),'LineWidth',3)
   xlim([0 110])
   ff=fft(surfaceElevation1(i,:));
   fff=ff(1:round(length(ff)/2));
   xfft1=Fs*(0:round(length(ff)/2-1))/round(length(ff));
   Abs_xfft1 = abs(fff)/length(xfft1);
%    ylabel('Surface Elevation(m)','interpreter','latex','FontSize',32)
%    xlabel('Time [s]','interpreter','latex','FontSize',32)
%    set(gca,'Fontsize',32)
%    title ('WaveProbe-Straightline','interpreter','latex','FontSize',32);
   
   subplot(3,1,2)
   plot(1:col2,surfaceElevation2(i,:),'LineWidth',3)
   xlim([0 110])
   ff=fft(surfaceElevation2(i,:));
   fff=ff(1:round(length(ff)/2));
   xfft2=Fs*(0:round(length(ff)/2-1))/round(length(ff));
   Abs_xfft2 = abs(fff)/length(xfft2);
%    ylabel('Surface Elevation(m)','interpreter','latex','FontSize',32)
%    xlabel('Time [s]','interpreter','latex','FontSize',32)
%    set(gca,'Fontsize',32)
%    title ('WaveProbe-Diagonalline','interpreter','latex','FontSize',32);
   subplot(3,1,3)
   plot(xfft1,Abs_xfft1,'LineWidth',3)
   hold on
   plot(xfft2,Abs_xfft2,'LineWidth',3)
   hold off
   legend('ProbeLine StraightLine','ProbeLine Diagonal')
    %xlim([0 100])
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    title('Frequency Domain signal')
    pause(0.01)
end