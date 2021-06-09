function sfftResult = sfftHarmonic(time,data,period,nHarmonic,nPeriod,hopPerPeriod)
%%% ------------------------------------------------------------------
%%%
%%%   Sliding fft results for given period with n Harmonic Analysis 
%%%
%%%   Input [Mandatory]
%%%       time   : given time [uniform spaced]
%%%       data   : given data [uniform spaced]
%%%       period : user defined period to extract
%%%
%%%   Input [Optional]
%%%       nHarmonic : number of harmonic [w 2w 3w ...]
%%%       nPeriod   : number of period used for sliding fft
%%%
%%%   No window function is applied for this subroutine.
%%%
%%%       Author : YoungMyung Choi (Ecole Centrale de Nantes)
%%%       Date   : 20th Mar. 2017
%%% 
%%% ------------------------------------------------------------------

if nargin == 3
    nHarmonic    = 5;
    nPeriod      = 1;
    hopPerPeriod = 1;
elseif nargin == 4
    nPeriod   = 1;
    hopPerPeriod = 1;
elseif nargin == 5
    hopPerPeriod = 1;
end

xlen = length(time);
[m n] = size(data);

sfftResult = [];

if m == xlen
    nVar = n;
elseif n == xlen
    nVar = m;
    data = data';
else
    return
end

dx = (time(end) - time(1)) / (xlen-1);
fs = 1/dx;

nWin = round(nPeriod * period / dx);
dataHop = round(nWin/hopPerPeriod);

for iVar = 1:nVar
    indx = 0;
    col = 1;
    while indx + nWin <= xlen
        % windowing
        xw = data(indx+1:indx+nWin,iVar);
        
        % FFT
        X = fft(xw,nWin);
        
        % update the stft matrix
        spectre = 2  * X / nWin;
        
        movingMeanAmp(iVar).data(col) = mean(xw);
        movingZeroAmp(iVar).data(col) = spectre(1)/2;
        for ih = 1:nHarmonic
            harmonicAmp(iVar).data(col,ih) = spectre(ih * (nPeriod+1));
        end
        
        indx = indx + dataHop;
        col = col + 1 ;
    end
end

coln = 1+fix((xlen-nWin)/dataHop);                  % calculate the total number of columns
t = (nWin/2:dataHop:nWin/2+(coln-1)*dataHop)/fs;

% sfftResult.time = t';
for iVar = 1:nVar
    sfftResult(iVar).time   = t';
    sfftResult(iVar).fft    = harmonicAmp(iVar).data;
    sfftResult(iVar).fftabs = abs(harmonicAmp(iVar).data);
    sfftResult(iVar).fftarg = angle(harmonicAmp(iVar).data);
    sfftResult(iVar).harmonicZero = movingZeroAmp(iVar).data;
    sfftResult(iVar).meanZero =  movingMeanAmp(iVar).data;
end

end
