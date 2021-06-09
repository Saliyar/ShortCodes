function [h, Lx, w_type, d, Ly] = get_basin_geom(basin)
% [h, Lx, w_type, d, Ly] = get_basin_geom(basin)
%
% Gives the basin and wavemaker geometry:
%   * h is the basin depth,
%   * Lx its length,
%   * w_type is the wavemaker type among 'flap' or 'piston',
%   * d is the hinge height for a flap wavemaker.
%   * Ly its width,
% All the distances are given in meters.
% The described basins are:
%   * the ECN towing tank (use basin='ECN_tow')
%   * the ECN wave basin  (use basin='ECN')
%
if strcmp(basin,'ECN')
    if nargout >= 1
        h      = 5.0;
    end
    if nargout >= 2
        Lx     = 50.0 - 3.6;
    end
    if nargout >= 3
        w_type = 'hinged';
    end
    if nargout >= 4
        d      = 2.147;
    end
    if nargout >= 5
        Ly = 29.60;
    end
elseif strcmp(basin,'ECN_tow')
    if nargout >= 1
        h      = 2.8;
    end
    if nargout >= 2
        Lx     = 65.0;
    end
    if nargout >= 3
        w_type = 'hinged';
    end
    if nargout >= 4
        d      = 0.5;
    end
    if nargout >= 5
        Ly = 5.0;
    end
else
    disp('Unknown wavemaker geometry in get_wgeo')
end
