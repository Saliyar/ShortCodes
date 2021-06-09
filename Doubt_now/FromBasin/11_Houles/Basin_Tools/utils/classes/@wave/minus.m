function wv = minus(wave1,wave2)
% wv = minus(wave1,wave2)
% @WAVE/MINUS Implement the - (soustraction) operator for two wave waves
% Inputs:
%   wave1 and wave2  are objects from wave class (cf. help wave)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave1 = wave(wave1);
wave2 = wave(wave2);
%
wv = wave1 + (-wave2);
