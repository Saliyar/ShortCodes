function wave_in = times(alpha,wave_in)
% wave_in = times(alpha,wave_in)
% WAVE/TIMES Implement the .* operator for a wave wave and a scalar
% Inputs:
%   wave_in  is an object from wave class (cf. help wave)
%   alpha    is a scalar (can be complex)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave_in = wave(wave_in);
%
wave_in = set(wave_in, 'wave', alpha .* get(wave_in,'wave'));
