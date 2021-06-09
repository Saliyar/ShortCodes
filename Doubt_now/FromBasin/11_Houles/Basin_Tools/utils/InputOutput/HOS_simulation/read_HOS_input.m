function input = read_HOS_input(directory, filename)
% input = read_HOS_input(directory, filename)
% LIB/SIMULATION/READ_HOS_INPUT
% Reads the input data contained in the HOS input file 
% (with only one argument, file implicitly named 'input_WestSideStory.dat')
% or 
% in the header of a HOS data file  and stores into an input structure
% (in this case, the file name is required, it can be either '3d.dat',
% 'probes.dat'...
% The variables' names in the structure are the same as in the HOS
% program
% 
% Félicien 21/04/2017
%
%% Argument check
if nargin < 1
    directory = '';
end
% input file name
if nargin == 1 || strcmp(filename, 'input_WestSideStory.dat')
    filename = 'input_WestSideStory.dat';
    comment  = '';
else
    comment = '#';
end
% making sure we have a '\' at the end of the directory name
if ~strcmp(directory(end),'\')
    directory = [directory '\'];
end
% open the filename
fid = fopen([directory filename]);
%
%% tank dimensions
line = fgets(fid);        % #!  ------ tank dimensions ---------------
line = fgets(fid);        % #   50.000 ! length(m) of the wavetank
input.xlen = sscanf(line,[comment '%g  ! length(m) of the wavetank\n']);
line = fgets(fid);        % #   29.740 ! beam(m) of the wavetank
input.ylen = sscanf(line,[comment '%g  ! beam(m) of the wavetank\n']);
line = fgets(fid);        % #    5.000 ! constant depth(m) of the wavetank
input.h    = sscanf(line,[comment '%g  ! constant depth(m) of the wavetank\n']);
%
%% which case
line = fgets(fid);         % #
line = fgets(fid);         % #!  -------------- which case ------------------
line = fgets(fid);         % # 31       ! 1: sloshing, 2: monochromatic wave train, 3: from file
input.icase = sscanf(line,[comment '%g  ! 1: sloshing, 2: monochromatic wave train, 3: from file\n']);
%
%% sloshing case
line = fgets(fid);          % #
line = fgets(fid);          % #!  -------------- sloshing case ------------------
line = fgets(fid);          % #  2       ! number of the natural mode
input.islosh = sscanf(line,[comment '%g  ! number of the natural mode\n']);
line = fgets(fid);          % #    0.100 ! amplitude (m) of the natural mode
input.aslosh = sscanf(line,[comment '%g  ! amplitude (m) of the natural mode\n']);
%
%% monochromatic case
line = fgets(fid);          % #
line = fgets(fid);          % #!  -------------- monochromatic case ------------------
line = fgets(fid);             % #    0.100 ! prescribed amplitude(m) of the wave train
input.ampFB     = sscanf(line,[comment '%g  ! prescribed amplitude(m) of the wave train\n']);
line = fgets(fid);             % #    0.400 ! prescribed frequency(Hz) of the wave train
input.nuFB      = sscanf(line,[comment '%g  ! prescribed frequency(Hz) of the wave train\n']);
line = fgets(fid);             % #    0.000 ! prescribed propagation angle(deg) from x-axis
input.thetaFB   = sscanf(line,[comment '%g  ! prescribed propagation angle(deg) from x-axis\n']);
line = fgets(fid);             % #    0.000 ! prescribed phasis(rad) of the wave train
input.phFB      = sscanf(line,[comment '%g  ! prescribed phasis(rad) of the wave train\n']);
line = fgets(fid);             % #    2 ! ibat		| 2. snake			| 3. Dalrymple
input.ibat      = sscanf(line,[comment '%g  ! ibat		| 2. snake			| 3. Dalrymple\n']);
line = fgets(fid);             % #   18.000 ! xdFB		| wave target distance    %	 Dalrymple (if ibat=3) 
input.xdFB      = sscanf(line,[comment '%g  ! xdFB		| wave target distance    %	 Dalrymple (if ibat=3) \n']);
line = fgets(fid);             % #  -0.2500 ! z_dipmono	| spinning dipole z-position from free surface (adim) (if igeom=3)
input.z_dipmono = sscanf(line,[comment '%g  ! z_dipmono	| spinning dipole z-position from free surface (adim) (if igeom=3)\n']);
line = fgets(fid);             % #  2       ! correction to cancel 2nd order free waves  (0 , 1 (regular) or 2 (irregular 2D))
input.ifree     = sscanf(line,[comment '%g  ! correction to cancel 2nd order free waves  (0 , 1 (regular) or 2 (irregular 2D))\n']);
line = fgets(fid);             % # 14       ! ocean like wavemaking: rnum number
input.rnum      = sscanf(line,[comment '%g  ! ocean like wavemaking: rnum number\n']);
line = fgets(fid);             % #   32.000 ! ocean like wavemaking: clockrate (Hz)
input.clock     = sscanf(line,[comment '%g  ! ocean like wavemaking: clockrate (Hz)\n']);
%
%% file case
line = fgets(fid);  % #
line = fgets(fid);  % #!  -------------- file case ------------------
line = fgets(fid);  % #regular1 ! name of the frequency file
input.file_name = sscanf(line,[comment '%s  ! name of the frequency file\n']);
line = fgets(fid);  % #  0       ! 0: no cutoff | 1: cutoff
input.i_cut     = sscanf(line,[comment '%g  ! 0: no cutoff | 1: cutoff\n']);
line = fgets(fid);  % #    0.150 ! low cut_off frequency (Hz) applied to the wave spectrum (if i_cut=1)
input.nuc_low   = sscanf(line,[comment '%g  ! low cut_off frequency (Hz) applied to the wave spectrum (if i_cut=1)\n']);
line = fgets(fid);  % #    1.500 ! high cut_off frequency (Hz) applied to the wave spectrum (if i_cut=1)
input.nuc_high  = sscanf(line,[comment '%g  ! high cut_off frequency (Hz) applied to the wave spectrum (if i_cut=1)\n']);
%
%% wavemaker
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ wavemaker ---------------------
line = fgets(fid);  % #  2       ! i_wmk		| 1. HOST-wm1	| 2. HOST-wm2	|3. HOST-wm3
input.i_wmk = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! igeom		| 1. piston	| 2. hinged | 3. spinning dipole
input.igeom = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  2       ! iwidth	| 1. full width	| 2. partial width
input.iwidth = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   18.000 ! dFB	   	| wavemaker rotation axis distance(m) from bottom (if igeom=2)
input.xdFB = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! x_dip	  	| spinning dipole x-position from left wall (if igeom=3)
input.x_dip = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0     ! n_side	| number of pairs of images on both sides
input.n_side = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! iramp		| 0. no time ramp	| 1. linear ramp	| 11. actual basin ramp	| 2. smooth ramp	
input.iramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 1: Tramp in time (s), 2: Tramp in wave periods
input.nramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    3.000 ! ramp duration
input.Tramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 0: no stop, 1: Tstop in time (s), 2: Tstop in wave periods
input.i_stop = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   40.000 ! time before stopping wavemaker
input.T_stop = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   29.740 ! length of the wavemaker (if iwidth=2 i.e. for B600)
input.ywmk = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! length of the left  part of the tank
input.yl = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! length of the right part of the tank
input.yr = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! size of the y-smoothing ramp (in % of wavemaker length)
input.y_rmp = sscanf(line,[comment '%g  ! \n']);
%
%% numerical beach 
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ numerical beach --------------
line = fgets(fid);  % #  0       ! absorption at 1st order (0 or 1)
input.iabs = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  0       ! absorption at 2nd order (0 or 1)
input.iabs2nd = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! absorption with a numerical beach (0 or 1)
input.iabsnb = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.800 ! beginning of the front numerical beach (ratio to xlen (e.g.: 0.8))
input.xabsf = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.800 ! beginning of the back numerical beach (ratio to xlen (e.g.: 0.8))
input.xabsb = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! beginning of the left  numerical beach (ratio to yl   (e.g.: 0.8))
input.yabsl = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! beginning of the right numerical beach (ratio to yr   (e.g.: 0.8))
input.yabsr = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    1.000 ! absorption strength on front beach
input.coeffabsf = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    1.000 ! absorption strength on back beach
input.coeffabsb = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! absorption strength on left  beach
input.coeffabsl = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! absorption strength on right beach
input.coeffabsr = sscanf(line,[comment '%g  ! \n']);
%
%% probes
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ probes ------------------------
line = fgets(fid);  % #  1       ! use of probes (0 or 1)
input.iprobes = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  2       ! 1: on the mesh, 2: on specific points
input.itypprobes = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #prob.inp ! filename of probe positon
input.pro_file = sscanf(line,[comment '%s  ! pro_file  | filename of probe positon\n']);
%
%% pressure
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ pressure ------------------------
line = fgets(fid);  % #  1       ! ipress	| use of pressure probes (0 or 1)
input.ipress = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  2       ! ityppress| 1: on the mesh, 2: on specific points
input.ityppress = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #prob.inp ! pres_file  | filename of pressure probe position
input.pres_file = sscanf(line,[comment '%s  ! pro_file  | filename of probe positon\n']);
%
%% discretization
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ discretization ----------------
line = fgets(fid);  % #       4  ! toler
input.toler = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #       4  ! f_out
input.f_out = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #129       !fft!	! number of nodes/modes used in x-direction
input.n1 = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % # 65       !fft!	! number of nodes/modes used in y-direction
input.n2 = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % # 17       !fft!	! number of nodes/modes used on the wavemaker (additional resolution)
input.n3 = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % # 3		! mHOS	    	! truncating order in HOS Taylor expansions
input.mHOS = sscanf(line,[comment '%g  ! \n']);
if strcmp(filename,'input_WestSideStory.dat')
    line = fgets(fid);  % # 1.0d0		! coeffilt		! filtering ratio in the truncated series of modes(-1 Cesaro;-2 Lanczos;-3 raised)
    input.coeffilt(1) = sscanf(line,[comment '%g  ! \n']);
    line = fgets(fid);  % # 1.0d0		! coeffilt		! filtering ratio in the truncated series of modes(-1 Cesaro;-2 Lanczos;-3 raised)
    input.coeffilt(2) = sscanf(line,[comment '%g  ! \n']);
    line = fgets(fid);  % # 1.0d0		! coeffilt		! filtering ratio in the truncated series of modes(-1 Cesaro;-2 Lanczos;-3 raised)
    input.coeffilt(3) = sscanf(line,[comment '%g  ! \n']);
    line = fgets(fid);  % # 1		! ismooth   ! smoothing level
    input.ismooth(1) = sscanf(line,[comment '%g  ! \n']);
    line = fgets(fid);  % # 1		! ismooth   ! smoothing level
    input.ismooth(2) = sscanf(line,[comment '%g  ! \n']);
else
    line = fgets(fid);  % # 1.0d0		! coeffilt		! filtering ratio in the truncated series of modes(-1 Cesaro;-2 Lanczos;-3 raised)
    input.coeffilt(1:3) = sscanf(line,[comment '%g  ! \n']);
    line = fgets(fid);  % # 1		! ismooth   ! smoothing level
    input.ismooth(1:2) = sscanf(line,[comment '%g  ! \n']);
end
%
%% output files
line = fgets(fid);  % #
line = fgets(fid);  % #!  --------- output files ---------------
line = fgets(fid);  % #  0       ! output of CPU times (0 or 1)
input.iCPUtime = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! outputs in adim (0) version or dim (1) version
input.iadim = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! free surface plot
input.i3d = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  0       ! modes plot
input.imodes = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! wavemaker motion plot
input.iwmk = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  0       ! modes for swensph simulations
input.iswensph = sscanf(line,[comment '%g  ! \n']);


%% End of file
fclose(fid);