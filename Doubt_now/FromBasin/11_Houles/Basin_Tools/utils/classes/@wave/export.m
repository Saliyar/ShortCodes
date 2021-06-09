function N_2000 = export(wv_2D, type, file_name)
% export(wv_2D, type, file_name)
% @WAVE/EXPORT Exports a wave object.
%   EXPORT(WV_2D, TYPE) exports the properties of the specified wave
%   object WV_2D in a file. The wanted properties are set with the TYPE
%   argument that can be
%
%       'cfg', 'config'       Config file only
%       'dat'                 Wave data only
%       'all', 'cfgdat'       Both confid and wave data
%
%   File name is set to default ('export.dat' and 'export.cfg')
%   EXPORT(WV_2D, TYPE, FILE_NAME) exports the specified wave object WV_2D
%   in the file FILE_NAME.
%   FILENAME can be a MATLABPATH relative partial pathname.
%
%   See also wave, wavemaker
%
if get(wv_2D,'dim') == 0
    error('wave object must be in dimensional form before export in wave/export')
end
if nargin == 1
    file_name = 'export';
    type      = 'all';
elseif nargin < 3 || strcmp(file_name,'')
    file_name = 'export';
else
    % Neglecting the file extension
    %     [pathstr, file_name] = fileparts(file_name);
end
switch type
    case {'cfg','config'}
        rnum = nextpow2(get(wv_2D,'T_repeat')) + 5;
        export(get(wv_2D,'wavemaker'), 'cfg', file_name, rnum);
    case 'dat'
        % Dalrymple method for export towards HOST or SWEET
        if strcmp(get(wv_2D, 'law'), 'Dalrymple') || strcmp(get(wv_2D, 'law'), 'dalrymple')
            wv_2D = dalrymple2snake(wv_2D);
        end
        harmo   = get(wv_2D, 'harmo');
        ampli   = get(wv_2D, 'ampli');
        ang     = get(wv_2D, 'angle');
        phase   = get(wv_2D, 'phase');
        % moduling phase to ]-pi;pi]
        ind = find(phase > pi);
        phase(ind) = phase(ind) - 2*pi;
        ind = find(phase <= -pi);
        phase(ind) = phase(ind) + 2*pi;
        % building wave data array
        f_base   = 1 / get(wv_2D,'T_repeat');
        data(:,1) = harmo.';
        data(:,2) = harmo.' * f_base;
        data(:,3) = ampli.';
        data(:,4) = ang.';
        data(:,5) = phase.';
        % Writing a dat file
        fid = fopen([file_name '.dat'],'w');
        fprintf(fid,'%i , %.4g , %.4g , %.3g , %.3g ,\r\n',data.');
        fclose(fid);
    case 'ocean'
        % ocean accepts files with 2000 components, no more...
        % Origin in ocean is in the wavemaker center
        % Dalrymple method for export towards wave-basin ocean software
        if strcmp(get(wv_2D, 'law'), 'Dalrymple') || strcmp(get(wv_2D, 'law'), 'dalrymple') || strcmp(get(wv_2D, 'law'), 'restricted')
            wv_2D = wave2snake(wv_2D);
        end
        % All the waves sent to export('dat') needs to be in snake to avoid
        % re-dalrymplization
        T_repeat = get(wv_2D, 'T_repeat');
        depth    = get(wv_2D, 'depth');
        L_y      = get(wv_2D, 'L_y');
        harmo = get(wv_2D,'harmonic');
        N_2000 = floor(get(harmo,'n_harmo')/2000)+1;
        for n=1:N_2000
            harmo_tmp = harmo((n-1)*2000+1:min(get(harmo,'n_harmo'),n*2000));
            tmp_harmo = get(harmo_tmp, 'harmo');
            k         = wave_number(tmp_harmo / T_repeat, depth);
            tmp_ampli = get(harmo_tmp, 'ampli');
            tmp_angle = get(harmo_tmp, 'angle')*pi/180; % ocean takes radians
            tmp_phase = get(harmo_tmp, 'phase') - k * L_y .* sin(tmp_angle)/2;    
            tmp_phase = mod(tmp_phase, 2*pi);
            harmo_tmp = harmonic(tmp_harmo, tmp_ampli, tmp_phase, tmp_angle);
            wv_tmp = wave(T_repeat, get(wv_2D, 'f_samp'), ...
                harmo_tmp, get(wv_2D, 'wmk'), control_law(0,'snake'));
            export(wv_tmp, 'dat', strcat(file_name,'_',num2str(n)));
        end
    case {'all','cfgdat'}
        % Writing a config file
        export(wv_2D, 'cfg', file_name);
        % Writing a dat file
        export(wv_2D, 'dat', file_name);
    case 'sweet'
        % Writing a config file
        export(wv_2D, 'cfg', file_name);
        % Writing a dat file
        if strcmp(get(wv_2D, 'law'), 'Dalrymple') || strcmp(get(wv_2D, 'law'), 'dalrymple')
            wv_exp = dalrymple(wv_2D);
        elseif strcmp(get(wv_2D, 'law'), 'snake')
            wv_exp = wv_2D;
        else
            error('don''t know what to do here')
        end
        export(wv_exp, 'dat', file_name);
    otherwise
        error('Unknown type of export in wavemaker/export')
end

