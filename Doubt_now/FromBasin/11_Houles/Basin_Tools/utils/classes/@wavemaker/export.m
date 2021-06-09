function export(wmk, type, file_name, rnum)
% @WAVEMAKER/EXPORT export the wavemaker properties from the specified
% object in a file
%
if wmk.dim == 0
    error('Wavemaker object must be in dimensional form before export in wavemaker/export')
end
if nargin < 3 || strcmp(file_name,'')
    file_name = 'export';
else
    % Neglecting the file extension
%     [pathstr, file_name] = fileparts(file_name);
end
if strcmp(type,'cfg') || strcmp(type,'config')
    % Writing a config file
    fid = fopen([file_name '.cfg'],'w');
    if nargin < 4
        disp('Warning !! value of rnum is undefined yet when exporting a wavemaker object (set to 1 by default)')
        fprintf(fid,'%g \r\n',1);            % rnum
    else
        fprintf(fid,'%g \r\n',rnum);         % rnum
    end
    fprintf(fid,'%g \r\n',32);               % clock
    fprintf(fid,'%g \r\n',wmk.depth);        % depth
    fprintf(fid,'%g \r\n',wmk.ramp);         % ramp
    fprintf(fid,'%s \r\n',wmk.type_ramp);    % typ_ramp
    fprintf(fid,'%g \r\n',0);                % cutoff_low
    fprintf(fid,'%g \r\n',4);                % cutoff_high
    fprintf(fid,'%g \r\n',wmk.Ly);           % Ly
    fprintf(fid,'%s \r\n',wmk.type);         % typ_wmk
    fprintf(fid,'%g \r\n',wmk.hinge_bottom); % hinge
    fclose(fid);
else
    error('Unknown type of export in wavemaker/export')
end

