function wl = wave_length(freq, depth)
% WAVE_LENGTH gives the wave length at given frequency 'freq' and depth
% through first order dispersion relation
%
%   wl = WAVE_LENGTH(FREQ) calculates the wave number assuming
%   dimensionless frequency
%   wl = WAVE_LENGTH(FREQ, DEPTH) uses the given depth and dimensionful
%   frequency
%
switch nargin
    case {1}
        k = wave_number(freq);
    case {2}
        k = wave_number(freq, depth);
end        
wl = 2*pi ./ k;