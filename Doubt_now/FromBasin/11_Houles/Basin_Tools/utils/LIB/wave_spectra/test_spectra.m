function test_spectra
% simple plot of the various spectra
% Frequency vector (in Hz)
freq = 0.1:0.01:2;
% Significant wave height
Hs = 0.2;
% Energy
m_0 = Hs^2/16;
% Peak frequency
f_p=0.5;
% COmpression factor for the PM ocean
Comp = 0.9;
%
S(:,1) = bretsch_ocean(freq,f_p,Hs^2/16);
S(:,2) = pm_ocean(freq,f_p,Comp);
S(:,3) = pm(freq,f_p);
S(:,4) = ITTC_ocean(freq,f_p,Hs);
% mean freq
f_m = sum(S(:,4).*freq') / sum(S(:,4));
S(:,5) = ITTC_ocean(freq,f_m,Hs);

figure(1)
plot(freq, S)
legend('Bretschneider ocean', ['PM ocean Comp=' num2str(Comp)], 'PM', 'ITTC ocean', 'ISSC ocean')