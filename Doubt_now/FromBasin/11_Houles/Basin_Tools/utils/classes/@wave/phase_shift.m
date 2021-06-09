function wv_2D = phase_shift(wv_2D, phi)
% wv_2D = phase_shift(wv_2D, phi)
% @WAVE/PHASE_SHIFT shifts the waves in the wave object of the
% given phase
% Inputs:
%   wv_2D  is an object from wave class (cf. help wave)
%   phi    is a scalar phase
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wv_2D = set(wv_2D, 'phase', get(wv_2D,'phase') + phi);