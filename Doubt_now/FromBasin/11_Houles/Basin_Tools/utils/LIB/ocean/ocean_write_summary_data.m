function ocean_write_summary_data(fid, ind, wv)
% OCEAN_WRITE_SUMMARY_DATA write the wave information into .txt file
%   ocean_write_summary_header(fid, ind, wv)
%   fid = ocean_write_summary_header(fid, ind, wv)
% Inputs
%   fid     ID of the opened .wav file
%   ind     index of the run
%   wv      wave object (see classes.pdf)
%
% See also ocean_write_summary_header.m, ocean_write_summary_irregular.m, ocean_write_header.m 
%
fprintf(fid, '/* Poly-chromatic wave data*/\n');
fprintf(fid, 'wave (or run) %i;\n', ind);
fprintf(fid, 'Period\tFrequency\tAmplitude\tHeight\tDirection\tPhase\n');
fprintf(fid, 's\tHz\tm\tm\tdeg\trad\n');
data = [make_it_column(get(wv,'Period')), make_it_column(get(wv,'Frequency')),...
        make_it_column(get(wv,'Amplitude')), make_it_column(get(wv,'Height')),...
        make_it_column(get(wv,'Direction')), make_it_column(get(wv,'Phase'))];
fprintf(fid, '%g\t%g\t%g\t%g\t%g\t%g\n',data.');


