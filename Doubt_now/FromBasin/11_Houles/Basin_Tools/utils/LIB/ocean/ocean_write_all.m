function ocean_write_all(wv, path, name, m, fid,fid_sum)

file_n = fullfile('data',strcat(name, '_', num2str(m)));
% ocean 2000 components rules
ocean_write_summary_data(fid_sum, m, wv)
N_2000 = export(wv, 'ocean', fullfile(path,file_n));
% data text
ocean_write_data_read(fid, file_n, m, N_2000)