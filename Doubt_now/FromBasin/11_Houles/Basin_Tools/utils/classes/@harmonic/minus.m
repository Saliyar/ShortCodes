function harmo = minus(harmo1,harmo2)
% harmo = minus(harmo1,harmo2)
% @HARMONIC/MINUS Implement the - (soustraction) operator for two harmonic
% objects
% Inputs:
%   harmo1 and harmo2  are objects from harmonic class (cf. help harmonic)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
harmo1 = harmonic(harmo1);
harmo2 = harmonic(harmo2);
%
harmo = harmo1 + (-harmo2);
