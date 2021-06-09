% Different wave analysis methods
% Some methods with a simple example

% Regular wave example
time=0:1/128:120;
A1=1;
A2=2/100;
T=2;
elevation=A1*cos(2*pi/T*time)+A2*cos(2*(2*pi/T)*time);
figure;
plot(time,elevation);

%1. Wave by Wave analysis
[wbw_up wbw_down] = wbw_analysis(time, elevation);

%2. Frequency domain analysis
f_houle= 0.1;
% Sélection de la fenêtre temporelle
[t_clic x] = ginput(2);
N = floor(diff(t_clic)*f_houle);
t(1) = t_clic(1);
t(2) = t(1) + N/f_houle;
for n=1:2
    subplot(2,1,n)
    add_vertical(t_clic, 'r')
    add_vertical(t, 'g')
end
[FT, freq] = Fourier_analysis(signal(:,[i_1 i_2]), time, f_houle, f_samp, t(1), N);

figure
stem(freq,abs(FT(:,1)))
xlabel('frequency (Hz)')
ylabel ('Spectrum components')

%3. Use of stream function
% Waverf
plot_flag=0;
[A_SF,B_SF,k_SF,Period,Amplitude,frequencies]=waverf(plot_flag);
subplot(ceil(length(probes_for_analysis)/2)+1,2,length(probes_for_analysis)+2);
    stem(frequencies,2*abs(A_SF)*   data.depth*1000,'r--','Linewidth',1.0)
      fig1=gca;
    fig1.GridLineStyle='--';
    fig1.GridAlpha=0.5;
    xlim([0 5.1/Period])
    xlabel('Frequency [Hz]','FontSize',8)
    ylabel('Hauteur [mm]','FontSize',8)
    fig1=gca;
    fig1.GridLineStyle='--';
    fig1.GridAlpha=0.5;
    X= frequencies;
    Y=2*abs(A_SF)*data.depth*1000;
for j=2:4
    strValues = strtrim(cellstr(num2str(Y(j) ,' %.1f')));
   text(X(j),Y(j),strValues,'VerticalAlignment','top','FontSize',8);
end
    title(['Spectre frequentiel fonction de courant'],'FontSize',8);