function write_inp(wv_2D, file_name, f_samp, T_propag)
% write_inp(wv_2D, file_name, f_samp, T_propag)
% @wave\WRITE_INP writes the wave elevation at the wavemaker from the wave details
% Inputs
%   wv_2D                is a wave object,
%   file_name            is the .inp file name,
%   f_samp (optional)    is the new sampling frequency
%   T_propag (optional)  is the time for the wavefield to propagate from the wavemaker to the desired  point for measurement.
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%

% Ramp duration
T_ramp = 5;
% Defining the total duration of the elevation that we want to generate
if nargin >= 4
    t_end  = T_ramp + T_propag + get(wv_2D,'T_repeat') + T_ramp;
else
    t_end  = T_ramp + get(wv_2D,'T_repeat') + T_ramp;
end
%
if nargin >= 3
    T_samp = 1.0 / f_samp;
else
    T_samp = 1.0 / get(wv_2D,'f_samp');
end
% Building the time vector
time   = 0:T_samp:t_end;
% Building the elevation
eta = eval_eta(wv_2D, time);
% Neglecting the file extension
[pathstr, name] = fileparts(file_name);
% Writing the file
fid             = fopen([name '.inp'],'w');
fprintf(fid,'%g \t %g \n',[time.' eta.']');
fclose(fid);
