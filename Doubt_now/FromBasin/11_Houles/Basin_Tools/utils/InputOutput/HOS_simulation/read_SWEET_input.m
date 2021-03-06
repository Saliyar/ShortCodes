function input = read_SWEET_input(directory, filename)
% input = read_SWEET_input(directory, filename)
% LIB/SIMULATION/READ_SWEET_INPUT
% Reads the input data contained in the SWEET input file 
% (with only one argument, file implicitly named 'input_SWEET.dat')
% or 
% in the header of a SWEET data file  and stores into an input structure
% (in this case, the file name is required, it can be either '3d.dat',
% 'probes.dat'...
% The variables' names in the structure are the same as in the SWEET
% program
% 
% F�licien 10/09/2009
%
%% Argument check
if nargin < 1
    directory = '';
end
% input file name
if nargin == 1 || strcmp(filename, 'input_SWEET.dat')
    filename = 'input_SWEET.dat';
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
line = fgets(fid);        % #0.000E+00 ! stiffness of the ice sheet
input.beta = sscanf(line,[comment '%g  ! stiffness of the ice sheet\n']);
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
line = fgets(fid);          % #    0.100 ! prescribed amplitude(m) of the wave train
input.ampFB   = sscanf(line,[comment '%g  ! prescribed amplitude(m) of the wave train\n']);
line = fgets(fid);          % #    0.400 ! prescribed frequency(Hz) of the wave train
input.nuFB    = sscanf(line,[comment '%g  ! prescribed frequency(Hz) of the wave train\n']);
line = fgets(fid);          % #    0.000 ! prescribed propagation angle(deg) from x-axis
input.thetaFB = sscanf(line,[comment '%g  ! prescribed propagation angle(deg) from x-axis\n']);
line = fgets(fid);          % #    0.000 ! prescribed phasis(rad) of the wave train
input.phFB    = sscanf(line,[comment '%g  ! prescribed phasis(rad) of the wave train\n']);
line = fgets(fid);          % #  2       ! correction to cancel 2nd order free waves  (0 , 1 (regular) or 2 (irregular 2D))
input.ifree   = sscanf(line,[comment '%g  ! correction to cancel 2nd order free waves  (0 , 1 (regular) or 2 (irregular 2D))\n']);
line = fgets(fid);          % # 14       ! ocean like wavemaking: rnum number
input.rnum    = sscanf(line,[comment '%g  ! ocean like wavemaking: rnum number\n']);
line = fgets(fid);          % #   32.000 ! ocean like wavemaking: clockrate (Hz)
input.clock   = sscanf(line,[comment '%g  ! ocean like wavemaking: clockrate (Hz)\n']);
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
line = fgets(fid);  % #  2       ! 1. piston	| 2. hinged | 3. spinning dipole | 4. bi-flap
input.igeom = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! Bi-flap case | 1.Top flap only | 2. Top=piston, bottom=flap | 3. Single flap | 4. ...
input.TF_mode = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  2       ! 2. snake			| 3. Dalrymple	| 4. B600
input.ibat = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   18.000 ! wave target distance(m)   %	 Dalrymple (if ibat=3)  %
input.xdFB = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 1. full width	| 2. partial width
input.iwidth = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    2.147 ! wavemaker bottom hinge height (m) from bottom (if igeom=2)
input.hinge = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! wavemaker middle flap length (m) (if igeom=4)
input.middle = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 0. no time ramp	| 1. smooth ramp	| 2. actual basin ramp	| 11. old ramp
input.iramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 1: Tramp in time (s), 2: Tramp in wave periods
input.nramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    3.000 ! ramp duration
input.Tramp = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #  1       ! 0: no stop, 1: Tstop in time (s), 2: Tstop in wave periods
input.i_stop = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   40.000 ! time before stopping wavemaker
input.T_stop = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #   60.000 ! time before stopping wavemaker
input.T_stop_simu = sscanf(line,[comment '%g  ! \n']);
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
line = fgets(fid);  % #    0.000 ! beginning of the left  numerical beach (ratio to yl   (e.g.: 0.8))
input.yabsl = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    0.000 ! beginning of the right numerical beach (ratio to yr   (e.g.: 0.8))
input.yabsr = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    1.000 ! absorption strength on front beach
input.coeffabsf = sscanf(line,[comment '%g  ! \n']);
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
line = fgets(fid);  % #  0       ! 0: no velocity field calculated, XX: velocity fields evaluated on z_points
input.z_points = sscanf(line,[comment '%g  ! \n']);
%
%% discretization
line = fgets(fid);  % #
line = fgets(fid);  % #!  ------ discretization ----------------
line = fgets(fid);  % #       4  ! 1: auto time step, 2: semi-auto, 3:non auto
input.iauto = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #5.603E-02 ! time step (adim)
input.delt = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #    1499  ! number of time steps in the simulation
input.ntime = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #       5  ! printing every ? time steps
input.nprint = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % #129       !fft!	! number of nodes/modes used in x-direction
input.n1 = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % # 65       !fft!	! number of nodes/modes used in y-direction
input.n2 = sscanf(line,[comment '%g  ! \n']);
line = fgets(fid);  % # 17       !fft!	! number of nodes/modes used on the wavemaker (additional resolution)
input.n3 = sscanf(line,[comment '%g  ! \n']);
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