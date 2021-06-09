function [Val, freq] = findValMaxFFT( fSig, y_absSig)

for i= 1:size(y_absSig,2)
    [Val(i),Ifreq(i)] = max(y_absSig(:,i));
    
    freq= fSig(Ifreq);
    
end
