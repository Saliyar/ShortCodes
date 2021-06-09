function wv_2D = position_shift(wv_2D, x)
% wv_2D = position_shift(wv_2D, x)
% @WAVE/POSITION_SHIFT shifts the waves in the wave object of the given position
% Inputs:
%   wv_2D  is an object from wave class (cf. help wave)
%   x      is a scalar position
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
k     = get(wv_2D,'wavenumber');
wv_2D = set(wv_2D, 'phase', get(wv_2D,'phase') - k*x);