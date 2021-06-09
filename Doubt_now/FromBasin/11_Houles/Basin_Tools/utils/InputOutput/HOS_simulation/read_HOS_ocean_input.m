%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%    Function read_HOS: read the data in the file
%%%%%%%%%%%%%%%%%%%    3d.dat in the case of unidirectional wavefield
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xlen,ylen,Hs,Tp,gamma,T_stop,f_samp,grav,depth,n1,n2,M] = read_HOS_ocean_input(FileName, PathName)

if nargin <1
    % Choose the data file you want to process
    [FileName,PathName] = uigetfile({'*.dat', 'HOS-ocean 3d files';...
        '*.*',  'All Files (*.*)'}, 'Input file');
end
[pathstr,name,ext] = fileparts(FileName);

if exist(fullfile(pathstr, [name '.mat']), 'file') == 2
    use_old = questdlg(['Use the existing ' name '.mat file ?'],'Which file to use','Yes');
    if strcmp(use_old,'Yes')
        load(fullfile(pathstr, [name '.mat']));
    elseif strcmp(use_old,'Cancel') | strcmp(use_old,'')
        return
    end
else
    use_old = 'No';
end

if strcmp(use_old, 'No')
    % open the file containing data
    fid = fopen(fullfile(PathName, FileName)); 

    %READ PARAMETERS OF SIMULATION (number of time-steps, duration of simulations, geometric caracteristics...) 

    % read the corresponding case
    line   = fgets(fid); i_case = sscanf(line,'#          Choice of computed case::        i_case::%i\n');

    if ((i_case~=3) & (i_case~=4) & (i_case~=41) & (i_case~=42) & (i_case~=43))
        error('on a un probleme, cas pas traité')
    end

    %skip 1 line
    for i=1:1
        fgets(fid);
    end; 


    %read xlen and ylen, lengthes along x and y of the domain 
    line   = fgets(fid); xlen = sscanf(line,'#            Length in x-direction::          xlen::%g\n'); 
    line   = fgets(fid); ylen = sscanf(line,'#            Length in y-direction::          ylen::%g\n'); 


    %skip 1 line
    for i=1:1
        fgets(fid);
    end; 


    %read T_stop and f_samp, duration of simulation and sampling frequency
    line   = fgets(fid); T_stop = sscanf(line,'#       Duration of the simulation::        T_stop::%g\n'); 
    line   = fgets(fid); f_samp = sscanf(line,'#      Sampling frequency (output)::         f_out::%g\n'); 
    %
    %skip 4 lines
    for i=1:4
        fgets(fid);
    end; 

    line   = fgets(fid); grav = sscanf(line,'#                          Gravity::          grav::%g\n'); 
    line   = fgets(fid); depth = sscanf(line,'#                      Water depth::         depth::%g\n');

    if (depth<=0)
        depth = 1e15;
    end

    %skip 1 line
    for i=1:1
        fgets(fid);
    end; 

    %read Tp/Hs/gamma
    line   = fgets(fid); Tp = sscanf(line,'#                 Peak period in s::       Tp_real::%g\n');
    line   = fgets(fid); Hs = sscanf(line,'#     Significant wave height in m::       Hs_real::%g\n');
    line   = fgets(fid); gamma = sscanf(line,'#                 JONSWAP Spectrum::         gamma::%g\n');
    
    %
    if ((i_case~=3))
        k0 = 1;
        Tp = 2*pi/sqrt(grav*k0*tanh(k0*depth));
    end

    %creation of a variable zone = duration*sampling_frequency = number of samples
    %zone is a vector of one line with T_stop * f_samp elements equals to T_stop * f_samp except the 1st which is 1. (Except if T_stop * f_samp=1, then it is [])
    zone   = floor(T_stop * f_samp)+1; 
    if zone==1
        error('only one sample')
    end
    N_zone = zone;
    zone(zone==1) = [];
    zone(2:zone) = zone;
    zone(1) = 1; 


    %skip 10 lines
    for i=1:10 
        fgets(fid);
    end;


    %read n1, n2 and M, number of points along x, y and order of nonlinearity
    line   = fgets(fid);  n1     = sscanf(line,'#      Modes number in x-direction::            n1::%i\n'); 
    line   = fgets(fid);  n2     = sscanf(line,'#      Modes number in y-direction::            n2::%i\n'); 
    line   = fgets(fid);  M      = sscanf(line,'#           HOS nonlinearity order::             M::%i\n'); 

end
