function val = SIGTransFour(varargin)

% Syntax
% val = SIGTransFour(s)
% val = SIGTransFour(s,OffsetNull)
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
        offsetNull =  0;
    else
        error('Wrong type of input arguments')
    end      
case 2  
    if (isa(varargin{1},'signal') && isa(varargin{2},'double'))
        s = varargin{1};
        offsetNull =  varargin{2};
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
df = fech/N;                %pas frequentiel

freq = [0:df:fech/2-df];    %vecteur frequences
Nf = length(freq);          %nb de freqences

four = fft(data);           %calcul fft
four = four([1:N/2]);       %prend la partie positive
modfft = abs(four)*2/N;%calcul du module

phafft=angle(four);         %calcul de la phase
DSPSignal=modfft.^2/2/df;   %calcul de la DSP 
%le module de la composante continue ne doit pas être multiplié par 2 en ce
%qui concerne la FFT % modifié le 20/02/2015 par A. Tassin
modfft(1)=modfft(1)/2;      
val = [freq' modfft phafft DSPSignal];


end






