clc; clear all; close all;

T = 2;
omega = 2*pi/T;
AmpAbs = 1;

nTime = 356;

% nTime = 2^8;

time = linspace(0, 30.2*T, nTime);

Amp = [AmpAbs, AmpAbs*0.5, AmpAbs*0.3];

data = Amp(1) * cos(omega * time) + Amp(2) * cos(2*omega * time) + Amp(3)*cos(3*omega * time);

nHarmonic    = 3;
nPeriod      = 4;
hopPerPeriod = 1;

sfftResult = sfftHarmonic_a(time, data, T, nHarmonic, nPeriod, hopPerPeriod);

figure(1)

for ihar = 1:nHarmonic
    subplot(nHarmonic,1,ihar)
    plot(sfftResult.time, sfftResult.fftabs(:, ihar))
    hold on
    plot([sfftResult.time(1), sfftResult.time(end)], [Amp(ihar), Amp(ihar)], 'k--')
    
    avgFFT = mean(sfftResult.fftabs(:, ihar));
    
    AmpResult(ihar) = avgFFT;
end

[Amp;AmpResult]
