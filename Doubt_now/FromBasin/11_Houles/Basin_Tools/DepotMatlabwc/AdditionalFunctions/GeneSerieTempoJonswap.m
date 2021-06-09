function sig = GeneSerieTempoJonswap(Tp,Hs,gamma,duree,fech)

%génération d'une série temporelle correspondant à un spectre
%Jonswap de paramètre Hs, Tp, et gamma.

%génération de la DSP du Jonswap
dt = 1/fech;
n = duree*fech;
df = fech/n;
freqc = [0:df:df*(n-1)/2];
alpha = ajonswap(Tp,Hs,gamma);
spectreJonswap = vjonswap(freqc,Tp,Hs,gamma,alpha);

%restrictions en fréquences
frqmin = 1/5; frqmax = 1/0.8; %parametres du batteur ou hexap
ind = find(freqc>frqmin & freqc<frqmax);
zer = zeros(1,length(spectreJonswap));
zer(ind) = spectreJonswap(ind);
spectreJonswap = zer;

%Passage à la trans de Four
%A est la fftJonswap
A = sqrt(spectreJonswap*df*2);
%génération des phases aléatoirement
graine = 1234;
rand('seed',graine);
phase = rand(1,length(A))*2*pi;
%Construction de la fft complexe pour ifft
Acomplexe = A.*exp(i*phase);
Acomplexe2 = [Acomplexe, conj(Acomplexe(end:-1:2))];
SigTemp = real(ifft(Acomplexe2)*n/2);  
temps = [0 :dt : (length(SigTemp)-1)/fech];

sig = signal(SigTemp,1/fech,'Jonswap','mm');

%vérification par fft
f = SIGTransFour(sig,1);


%affichage de graphs
figure;
subplot(311);
plot(freqc,spectreJonswap,'r-','LineWidth',2);grid on; hold on;
plot(f(:,1),f(:,4));
xlabel('freq(Hz)');ylabel('DSP Jonswap');xlim([0 2]);
tit = sprintf('Jonswap Spectrum\nHs=%3.1f Tp=%3.1f Gamma=%3.1f',Hs,Tp,gamma);
title(tit);

subplot(312);
plot(freqc,A,'r-','LineWidth',2); grid on; hold on;
plot(f(:,1),f(:,2));
xlabel('freq(Hz)');ylabel('FFT Jonswap');xlim([0 2]);

subplot(313);
plot(temps,SigTemp);
