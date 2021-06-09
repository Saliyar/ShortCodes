function info_var = info(input, var, depth)
% info_var = info(input, var, depth)
% @INFO\INFO info class constructor.
%   choose the information type for a wave (angular frequency, period, frequency, wavenumber or wavelength)
%   info_var = info(input) returns a info object named info_var, with input and other default values
%
switch nargin
    case 0
        info_var.input  = 'frequency';
        info_var.dim    = 0;
        info_var.depth  = 0;
        info_var.omega  = 0;
        info_var.period = 0;
        info_var.freq   = 0;
        info_var.k      = 0;
        info_var.lambda = 0;
        % telling matlab wv the class of the build object
        info_var = class(info_var,'info');
    case 1 % no arguments => we're building a default wave information
        if isa(input,'info')
            info_var = input;
        else
            error('Wrong argument type')
        end
    case {2,3} % arguments are provided => we're building the wave information
        info_var.input = input;
        if nargin >= 3
            % depth is provided
            info_var.dim   = 1;
            info_var.depth = depth;
        else % non dimensional input
            info_var.dim   = 0;
            info_var.depth = 0;
        end
        switch input
            case 'pulsation'
                info_var.omega  = var;
                info_var.period = 2*pi/var;
                info_var.freq   = var/(2*pi);
                if info_var.dim == 0
                    info_var.k      = wave_number(info_var.freq);
                else
                    info_var.k      = wave_number(info_var.freq, depth);
                end
                info_var.lambda = 2*pi/info_var.k;
            case 'period'
                info_var.omega  = 2*pi/var;
                info_var.period = var;
                info_var.freq   = 1/var;
                if info_var.dim == 0
                    info_var.k      = wave_number(info_var.freq);
                else
                    info_var.k      = wave_number(info_var.freq, depth);
                end
                info_var.lambda = 2*pi/info_var.k;
            case 'frequency'
                info_var.omega  = 2*pi*var;
                info_var.period = 1/var;
                info_var.freq   = var;
                if info_var.dim == 0
                    info_var.k      = wave_number(info_var.freq);
                else
                    info_var.k      = wave_number(info_var.freq, depth);
                end
                info_var.lambda = 2*pi/info_var.k;
            case 'wavenumber'
                if info_var.dim == 0
                    info_var.omega = sqrt(var * tanh(var));
                else
                    info_var.omega = sqrt(9.81 * var * tanh(var * depth));
                end
                info_var.period = 2*pi / info_var.omega;
                info_var.freq   = info_var.omega / (2*pi);
                info_var.k      = var;
                info_var.lambda = 2*pi/info_var.k;
            case {'wavelength' 'lambda'}
                if info_var.dim == 0
                    info_var.omega = sqrt(2*pi/var * tanh(2*pi/var));
                else
                    info_var.omega = sqrt(9.81 * 2*pi/var * tanh(2*pi/var * depth));
                end
                info_var.period = 2*pi/info_var.omega;
                info_var.freq   = info_var.omega / (2*pi);
                info_var.k      = 2*pi/var;
                info_var.lambda = var;
            otherwise
                disp('Unknown wave info type')
                info_var.period = 1;
                info_var.omega  = 1;
                info_var.freq   = 1;
                info_var.k      = 1;
                info_var.lambda = 1;
        end
        info_var = class(info_var,'info');
    otherwise
        error('Wrong number of input arguments')
end
