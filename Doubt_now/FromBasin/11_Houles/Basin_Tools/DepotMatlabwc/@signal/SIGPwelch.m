function val = SIGPwelch(varargin)

% Syntax
% val = SIGTransFour(s)
% val = SIGTransFour(s,OffsetNull)
%val = SIGTransFour(s,OffsetNull,{window,noverlap,nfft})
%
%Calculates the Fourier Transform of signal object s
%and returns in val : 
%- le vecteur colonne frequences
%- le vecteur colonne module de la trans de Fourier
%- le vecteur colonne phase de la trans de Fourier
%- le vecteur colonne DSP
%
%si offsetNull = 1 la valeur moy est soustraite

switch nargin
case 1 
    if (isa(varargin{1},'signal'))
        s = varargin{1};
        offsetNull=0;
        paramPwelch={[],[],[]};
    else
        error('Wrong type of input arguments')
    end      
case 2  
    if (isa(varargin{1},'signal') && isa(varargin{2},'double'))
        s = varargin{1};
        offsetNull =  varargin{2};
        paramPwelch={[],[],[]};
    else
        error('Wrong type of input arguments')        
    end
case 3  
    if (isa(varargin{1},'signal') && isa(varargin{2},'double')  && isa(varargin{3},'cell'))
        s = varargin{1};
        offsetNull =  varargin{2};
        paramPwelch=varargin{3};
    else
        error('Wrong type of input arguments')        
    end

    otherwise
   error('Wrong number of input arguments')
end

data = s.Y;

if offsetNull == 1
    tare = mean(data);   
    data = data-tare;
end

N = length(data);           %nb points
 fech = 1/s.dt;              %freq echantillonnage
% df = fech/N;                %pas frequentiel

% freq = [0:df:fech/2];    %vecteur frequences
% Nf = length(freq);          %nb de freqences

%data=data(1:end-100);
[dspsmooth,freq1]=pwelch(data,paramPwelch{1},paramPwelch{2},paramPwelch{3},fech);
% [dspsmooth2,freq2]=pwelch(data,5000,2500,[],100);
% [dspsmooth3,freq3]=pwelch(data,2500,1250,[],100);
% [dspsmooth4,freq4]=pwelch(data,1250,1250/2,[],100);
% iw=8192;
% dspsmooth2=dspsmooth1*0;
% while ((iw < 16384))
% iw=iw+1    
% [dspsmooth2,freq1]=pwelch(data,iw,[],[],100);
% 
% errdsp(iw-8192)=sum((dspsmooth2-dspsmooth1).^2);
% end
%figure, plot(errdsp)

% figure, plot(freq1,dspsmooth1)
% hold on, plot(freq2,dspsmooth2,'r')
% hold on, plot(freq3,dspsmooth3,'-g+')
% hold on, plot(freq4,dspsmooth4,'-k.')
% xlim([0 1]);
%Nf=length(dspsmooth);

%freq2=[0:pi/(Nf-1):pi]*fech/2;
% four = fft(data);           %calcul fft
% four = four([1:N/2]);       %prend la partie positive
% modfft = abs(four)*2/N;%calcul du module
% 
% phafft=angle(four);         %calcul de la phase
% DSPSignal=modfft.^2/2/df;   %calcul de la DSP 
% %le module de la composante continue ne doit pas être multiplié par 2 en ce
% %qui concerne la FFT % modifié le 20/02/2015 par A. Tassin
% modfft(1)=modfft(1)/2;      
val = [freq1 dspsmooth];


end






