function out = group_velocity(frequency, wavenumber, depth)
% group_velocity(frequency, wavenumber, depth)
%GROUP_VELOCITY computes the group velocity for waves at frequency 'freq', wavenumber 'k' and 
%depth 'h'
v_p = phase_velocity(frequency, wavenumber);
tmp = 2 * wavenumber * depth;
out = v_p .* (1 + tmp ./ sinh(tmp)) / 2;

