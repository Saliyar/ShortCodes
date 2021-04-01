clear all; clc; close all;
%% Inputs 
%% 
amp = 0.045;
om = 1.3;
T = 2*pi/om;

%% Read data from CFD
fid = fopen('forces.dat','r');
ii = 1;
while ~feof(fid)
    tline = fgetl(fid);
    if tline(1) == "#"
        %skip for headlines
    else
        tline = split(tline)';
        for jj = 1:length(tline)
            temp = split(tline(jj),["(",")"]);
            for k = 1:length(temp) 
                if temp(k) ~="" 
                    data(ii,jj) = str2num(cell2mat(temp(k))); 
                end
            end

        end
        ii = ii+1;
    end
end
time = data(2:end,1);
len = length(time); %length of signal
dt = time(2) - time(1);
fs = 1/dt; %sampling period
Fp = [data(2:end,2),data(2:end,3),data(2:end,4)].*1; %for full geometry(in openFOAM, considered as half body)
mean(Fp(10:round(T/dt)))
for ii = 1:3
   Fp(:,ii) = Fp(:,ii) - mean(Fp(10:10+round(T/dt),ii)); %mean value extracted
end

%% Fil
% fc = 5; %cut off frequency
% [b,a]=butter(2,fc/(fs/2),'low');
% % fc = [0.1 1]; %cut off frequency
% % [b,a]=butter(2,fc/(fs/2),'bandpass');
% % Filtering to suppress the step in the signals
% Fp = filtfilt(b,a,Fp);
%% Prototype Information
scale = 20;
nu = 0.0010042; %water dynamic viscousity
mu = 0.000001006; %water kinematic viscousity
rho = 1000;
grav = 9.81;
Dc = 0.28; Dd = 0;
td = 0/scale;
M = 663000/scale^3;
Sw = pi*(Dc/2)^2;
Sd = pi*Dd^2/4;
z = 1/pi*sqrt(Dd^2-Dc^2);
A33th = 1/12*rho*(2*Dd^3 + 3*pi*Dd^2*z - pi^3*z^3 - 3*pi*Dc^2*z);
omn = sqrt((rho*grav*Sw)/(M + A33th));


KC = 2*pi*amp/Dd;
beta = Dd^2*1/T/nu;

dis = amp.*sin(om*time);
vel = om*amp*cos(om*time);
acc = -om^(2)*amp*sin(om*time);
Fk = -dis*Sw*rho*grav;
Fhyd = Fp(:,ii) - Fk; %hydrostatic force is extraced
Cf = Fhyd/(1/2*rho*(om*amp)^2*Sd);

figure(2)
plot(time,Fp(:,3),'k');
hold on 
plot(time,Fk,'--b');
plot(time,Fhyd,'r');
legend('Pressure force','Restoring force','Hydrodynamic force')
grid on
xlabel('time [s]'),ylabel('force')

figure(3)
plot(time/T,Cf,'k')
grid on
xlabel('Time/Twave [-]');ylabel('Cf in Z direction [-]');
hold on
plot(time/T,dis/amp, '--b')
legend('Cf','xi3/amp')
figure(4)

%% FFT for checking
f = fs*(0:(len/2))/len;
Y = fft(Fhyd);
P2 = abs(Y/len);
P1 = P2(1:len/2+1);
P1(2:end-1) = 2*P1(2:end-1);
figure(4)
plot(f,P1)
ph = angle(Y(5));
119*cos(ph)/(om^2*amp)/A33th
P1(5)*cos(ph)/((2*pi*f(5))^2*amp)/A33th
P1(5)*sin(ph)/((2*pi*f(5))*amp)
xlim([0 5])
%% Added mass Damping
Tstart = 1;
inds = 1/dt; %s
inde = round(inds + T/dt);

a33 = 2/(T*om^2*amp)*trapz(Fhyd(inds:inde).*sin(om*time(inds:inde)))*dt
a33_p = a33/A33th
b33 = -2/(T*om*amp)*trapz(Fhyd(inds:inde).*cos(om*time(inds:inde)))*dt
b33_p = b33/(om*A33th)


Ma_test = (T/(2*pi))^2*rho*grav*Sw-329