function wave_in = rotate(wave_in, theta)
% wave_in = rotate(wave_in, theta)
% @WAVE/ROTATE rotates the wave "wave_in" of an angle theta
% Inputs: 
%   wave_in  is an object from wave class (cf. help wave)
%   theta    is a scalar (in radians)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave_in = wave(wave_in);
% angle
wave_in = set(wave_in, 'wave', rotate(get(wave_in,'wave'),theta));
