function wv = harmonic(harmo, ampli, phase, angle)
% wv = harmonic(harmo, ampli, phase, angle)
% @HARMONIC\HARMONIC harmonic class constructor 
%    (equivalent to "front" in 'wave' language).
%
%    wv = HARMONIC() returns a default wave.
%
%    wv = HARMONIC(harmo, ampli) returns a wave with an harmonic number so that
%    the frequency will be defined later in wave_2D object where T_repeat
%    must be defined. The amplitude ampli is in m.
%
%    wv = HARMONIC(harmo, ampli, phase) same with initial phase in
%    radians (default 0)
%
%    wv = HARMONIC(harmo, ampli, phase, angle) same with angle in degrees from the
%    normal to the wavemaker(default 0)
%
%    default values may be used by empty arguments []
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also get, plus, display, rotate, times, convert2nondim,
%    convert2dim, length, isempty, uminus, minus

% default phase
phase_def = 0;
% default direction
angle_def = 0;
%
switch nargin
    case 0 % default object
        wv.dim      = 1;
        wv.n_harmo  = 0;
        wv.harmo    = [];
        wv.ampli    = [];
        wv.phase    = []; 
        wv.angle    = [];
        % telling matlab wv the class of the build object
        wv          = class(wv,'harmonic');
    case 1
        if isa(harmo,'harmonic')
            wv = harmo;
        else
            error('Wrong argument type')
        end
    case {2,3,4}
        % input must be in dimensional form
        wv.dim      = 1;
        % evaluating and storing the number of components
        s = max([length(harmo),length(ampli)]);
        if nargin >= 3
            s = max([s,length(phase)]);
            if isempty(phase)
                phase = phase_def;
            end
        end
        if nargin == 4
            s = max([s,length(angle)]);
            if isempty(angle)
                angle = angle_def;
            end
        end
        wv.n_harmo  = s;
        % harmonic numbers
        wv.harmo    = complete_vector(make_it_row(harmo),s);
        % amplitudes
        wv.ampli    = complete_vector(make_it_row(ampli),s);
        % phases (optional)
        if nargin >= 3
            wv.phase = complete_vector(make_it_row(phase),s);
        else
            wv.phase = complete_vector(phase_def,s);
        end
        % angles (optional)
        if nargin == 4
            wv.angle = complete_vector(make_it_row(angle),s);
        else
            wv.angle = complete_vector(angle_def,s);
        end
        % telling matlab wv the class of the build object
        wv              = class(wv,'harmonic');
    otherwise
        error('Wrong number of input arguments')
end
