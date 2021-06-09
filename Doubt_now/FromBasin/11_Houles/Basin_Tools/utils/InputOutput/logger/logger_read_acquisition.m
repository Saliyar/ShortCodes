function [f_samp, t_zero] = logger_read_acquisition(fid)
%LOGGER_READ_ACQUISITION reads some parameters from the acquisition cluster
% in logger.vi
% [f_samp, t_zero] = logger_read_acquisition(fid)
% fid       valid file identifier
%
% f_samp    sampling frequency in Hz
% t_zero    length of the offset measurements in s
%
% See also logger_read_data, logger_read_calibration
%
frewind(fid);
line_Acq = logger_read_keyword(fid, 'Acquisition :');
% on the seventh line
header = textscan(fid, '%s\t%s\t%f\t%d\t%f\t%f\t%d\t%s\t%d\t%u.%u.%u.%u\n', ...
    'WhiteSpace', '', 'Delimiter', '\t');
f_samp =   header{3};
t_zero =   header{5};
%
pathname  = header{1};
extension = header{2};
offsets   = header{4};
t_acq_max = header{6};
triggered = header{7};
balance   = header{8};
qualisys  = header{9};
IP_addr   = [header{10},header{11},header{12},header{13}];
    
% Example
% C:\Essais\Sonde_a_Houle\Etalonnage\février_2015	dat	100.000	1	3.000	20.000	0	6D7	1	130.66.119.101

