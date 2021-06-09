function wmk = wavemaker(depth, type, hinge_bottom, middle_flap, n_paddles, Ly, type_ramp, ramp)
% WAVEMAKER class constructor.
%   wmk = WAVEMAKER(depth) returns a wavemaker object named wmk with waterdepth depth
%   specified in meters (default 5 m.),
%
%   wmk = WAVEMAKER(depth, type) returns a wavemaker object with a "type"
%   wavemaker type (default 'hinged')
%
%   wmk = WAVEMAKER(depth, type, hinge_bottom) returns a wavemaker
%   object with a specified bottom hinge height (default 2.147 m.) measured from bottom
%
%   wmk = WAVEMAKER(depth, type, hinge_bottom, middle_flap) returns a
%   wavemaker object with  a specified middle_flap (default [])
%
%   wmk = WAVEMAKER(depth, type, hinge_bottom, middle_flap, typ_ramp) returns a wavemaker object
%   with a given type of ramp (ECN wave basin ramp is 'lin', it could also
%   be 'no' or 'quad' for numerical simulations) (default 'lin'),
%
%   wmk = WAVEMAKER(depth, type, hinge_bottom, middle_flap, ramp, ramp) returns a wavemaker object
%   with a starting ramp length ramp in clock cycles (default 32),
%
%   wmk = WAVEMAKER(depth, type, hinge_bottom, middle_flap, ramp, typ_ramp, Ly) returns a wavemaker 
%   object with a Ly basinwidth (default 29.74m.)
%
%   default values can be accessed with an empty argument [].
%
[depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def] = build_defaults('ECN_wave');
switch nargin
    case 0 % default object
        % Default values are the ECN wave basin ones
        [depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def] = build_defaults('ECN_wave');
        wmk = wavemaker(depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def);
        wmk = struct(wmk);
        % telling matlab wv the class of the build object
        wmk = class(wmk,'wavemaker');
    case 1
        if isa(depth,'wavemaker')
            wmk = depth;
        elseif ischar(depth)
           [depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def] = build_defaults(depth);
           wmk = wavemaker(depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def);
        else
            error('Wrong argument type')
        end
    case {2,3,4,5,6,7,8}
        wmk.dim = 1; % it means that the wavemaker is built with dimensional values (unless h=1)
        % it also means that the ramp duration is badly defined if a non
        % dimenional object is required (h=1)
        % depth definition
        if isempty(depth) % default value required by user
            wmk.depth = depth_def;
        else
            wmk.depth = depth;
        end
        %
        % wavemaker type (should be specified otherwise the previous test has exited)
        if isempty(type) % default value required by user
            wmk.type = type_def;
        else
            wmk.type = type;
        end
        %
        % bottom hinge height, measured from bottom
        if nargin >= 3
            if strcmp(wmk.type, 'piston') % just in case
                wmk.hinge_bottom = - Inf;
            elseif isempty(hinge_bottom) % default value required by user
                wmk.hinge_bottom = hinge_bottom_def;
            else
                wmk.hinge_bottom = hinge_bottom;
            end
        else % default value (wavemaker is probably a piston type)
            if strcmp(wmk.type, 'piston')
                wmk.hinge_bottom = - Inf;
            else
                wmk.hinge_bottom = hinge_bottom_def;
            end
        end
        %
        % middle panel height
        if nargin >= 4
            if isempty(middle_flap) % default value required by user
                wmk.middle_flap = middle_flap_def;
            else
                wmk.middle_flap = middle_flap;
            end
        else % default value (wavemaker is probably a piston type)
            wmk.middle_flap = middle_flap_def;
        end
        %
        % numbers of pannels definition
        if nargin >= 5
            if isempty(n_paddles) % default value required by user
                wmk.n_paddles = n_paddles_def;
            else
                wmk.n_paddles = n_paddles;
            end
        else % default value
            wmk.n_paddles = n_paddles_def;
        end
        %
        % basin width
        if nargin >= 6
            if isempty(Ly) % default value required by user
                wmk.Ly = Ly_def;
            else
                wmk.Ly = Ly;
            end
        else % default value
            wmk.Ly = Ly_def;
        end
        %
        % type_ramp definition ('lin' for fitting experiments)
        if nargin >= 7
            if isempty(type_ramp) % default value required by user
                wmk.type_ramp = type_ramp_def;
            else
                wmk.type_ramp = type_ramp;
            end
        else % default value
            wmk.type_ramp = type_ramp_def;
        end
        %
        % sramp definition in clock cycles
        if nargin >= 8
            if isempty(ramp) % default value required by user
                wmk.ramp = ramp_def;
            else
                wmk.ramp = ramp;
            end
        else % default value
            wmk.ramp = ramp_def;
        end
        %
        %
        % telling matlab wv the class of the build object
        wmk = class(wmk,'wavemaker');
    otherwise
        error('Wrong number of input arguments')
end

function [depth_def, type_def, hinge_bottom_def, middle_flap_def, n_paddles_def, Ly_def, type_ramp_def, ramp_def] = build_defaults(type)
switch type
    case 'ECN_wave'
        depth_def        = 5;
        type_def         = 'monoflap';
        hinge_bottom_def = 2.147;
        middle_flap_def  = 0;
        n_paddles_def    = 48;
        Ly_def           = 29.74;
        type_ramp_def    = 'lin';
        ramp_def         = 32;
    case 'ECN_small'
        depth_def        = 0.92;
        type_def         = 'monoflap';
        hinge_bottom_def = -(depth_def + 1 - 0.3);
        middle_flap_def  = 0;
        n_paddles_def    = 1;
        Ly_def           = 10;
        type_ramp_def    = 'lin';
        ramp_def         = 32;
    case 'ECN_towing'
        depth_def        = 2.9;
        type_def         = 'monoflap';
        hinge_bottom_def = 0.47;
        middle_flap_def  = 0;
        n_paddles_def    = 1;
        Ly_def           = 5.0;
        type_ramp_def    = 'lin';
        ramp_def         = 32;
    case 'B600'
        depth_def        = 7;
        type_def         = 'biflap';
        hinge_bottom_def = 2.0;
        middle_flap_def  = 3.5;
        n_paddles_def    = 1;
        Ly_def           = 15.0;
        type_ramp_def    = 'quad';
        ramp_def         = 5;
    case 'B600_wave'
        depth_def        = 3;
        type_def         = 'monoflap';
        hinge_bottom_def = 1.5;
        middle_flap_def  = 0;
        n_paddles_def    = 24;
        Ly_def           = 15.0;
        type_ramp_def    = 'lin';
        ramp_def         = 32;
    otherwise
        error('Unknown type of wavemaker')
end