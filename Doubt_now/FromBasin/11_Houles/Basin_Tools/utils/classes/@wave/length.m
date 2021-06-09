function len = length(wave1)
% wv = length(wave1)
% @WAVE/length Implement the length operator for a wave
% Inputs:
%   wave1 is an object from wave class (cf. help wave)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave1 = wave(wave1);
%
len = length(get(wave1, 'harmo'));
