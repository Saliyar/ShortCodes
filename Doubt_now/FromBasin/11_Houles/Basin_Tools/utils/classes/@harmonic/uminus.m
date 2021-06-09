function harmo = uminus(harmo1)
% harmo = uminus(harmo1)
% @HARMONIC/UMINUS Implement the - (unary minus) operator for an harmonic
%
% Inputs:
%   harmo1 is an object from harmonic class (cf. help harmonic)
%
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
harmo1 = harmonic(harmo1);
%
harmo = set(harmo1, 'phase', get(harmo1,'phase') + pi);
