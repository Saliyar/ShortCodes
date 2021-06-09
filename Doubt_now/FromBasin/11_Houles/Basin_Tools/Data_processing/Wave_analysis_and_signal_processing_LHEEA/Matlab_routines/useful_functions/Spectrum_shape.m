function [Spectrum,alpha] = Spectrum_shape(Hs,Tp,w,gamma)
% ->[Spectrum,alpha] = Spectrum_shape(Hs,Tp,w,gamma)
% OUTPUTS: 
% - Spectrum: S(w) for a JONSWAP/P-S spectrum with INPUTS defining the parameters
% - alpha : For a given gamma, alpha allows Hs=H_mo
    wp=2*pi/Tp;
    Spectrum=zeros(1,length(w));
    Aspectr=5/16*Hs^2*wp^4;
    Bspectr=5/4*wp^4;
    % On calcule les spectres avec problème dimensionnalisation  (alpha)         
    for i=1:length(w)
        if w(i)<wp
            sigma=0.07;
        else
            sigma=0.09;
        end
        Spectrum(i)=(1-0.287*log(gamma))*Aspectr/(w(i)^5)*exp(-Bspectr/(w(i)^4))*gamma^(exp(-(w(i)-wp)^2/(2*sigma^2*wp^2)));
    end
    % Alpha value adjustement
    m_0=trapz(w,Spectrum);
    alpha=Hs^2/(16*m_0);% on recalcule alpha pour avoir 'Hs' = Hmo
    Spectrum=alpha*Spectrum;
    m_0=trapz(w,Spectrum);
    Hm0=4*sqrt(m_0);
    if abs(Hm0-Hs)>=0.01*Hs
        disp ('caution ! alpha not well ajusted')
        sprintf(' Hm0= %g and Hs= %g ',Hm0, Hs)
    end
    
    if gamma==0 % WHITE NOISE SPECTRUM
        Spectrum=zeros(1,length(w));
        wmin=2*pi*0.04;
        wmax=2*pi*0.17;
        index_begin =find(abs(w-wmin)==min(abs(w-wmin)));
        index_end =find(abs(w-wmax)==min(abs(w-wmax)));
        
        Spectrum(index_begin:index_end)=Hs^2/(16*(wmax-wmin));
    end
end

