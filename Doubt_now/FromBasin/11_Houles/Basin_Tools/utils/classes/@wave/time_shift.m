function wv_2D = time_shift(wv_2D, time)
% wv_2D = time_shift(wv_2D, time)
% @WAVE/TIME_SHIFT shifts the waves in the wave object of the given time
% Inputs:
%   wv_2D  is an object from wave class (cf. help wave)
%   time   is a scalar time
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
omega = get(wv_2D,'pulsation');
wv_2D = set(wv_2D, 'phase', get(wv_2D,'phase') + omega*time);