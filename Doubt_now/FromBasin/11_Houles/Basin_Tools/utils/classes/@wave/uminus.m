function wv = uminus(wave1)
% wv = uminus(wave1)
% @WAVE/UMINUS Implement the - (unary minus) operator for a wave
% Inputs:
%   wave1 is an object from wave class (cf. help wave)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave1 = wave(wave1);
%
wv = set(wave1, 'harmonic', - get(wave1,'harmonic'));
