function logical = isempty(wave1)
% logical = isempty(wave1)
% @WAVE/ISEMPTY Implement the isempty function for an wave object
%   wave1 is an object from wave class (cf. help wave)
%
wave1   = wave(wave1);
%
logical = isempty(get(wave1, 'harmonic'));