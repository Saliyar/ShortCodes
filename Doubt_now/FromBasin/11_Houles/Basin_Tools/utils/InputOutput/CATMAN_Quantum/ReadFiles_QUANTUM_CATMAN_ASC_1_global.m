function ReadFiles_QUANTUM_CATMAN_ASC_1_global(varargin)


if nargin == 0
[filename , pathname, ~] = uigetfile( ...
{ '*.ASC','ASC-file (*.ASC)'}, ...
   'Selectionner le fichier de mesure du QUANTUM CATMAN ASCII (.ASC) ', ...
   'MultiSelect', 'off');
    %wait bar**********************
    h = waitbar(0, 'Please wait...');
    set(h, 'WindowStyle','modal', 'CloseRequestFcn','');
    for i=1:10
        waitbar(i/10, h);
        pause(.02)
    end
    delete(h)
    
elseif nargin  ==2
    pathname = varargin{1};
    filename = varargin{2};
else
    display('dont know what to do')
end

global data;
data.file.analog = 1;

data.probes.filename = filename;
data.probes.pathname = pathname;
data.probes.fdata = filename;

[time,probes,voltage ] = ReadFiles_QUANTUM_CATMAN_ASC_1(pathname, filename);

%name probes
data.time.time = time;
data.probes = probes;
data.voltage.global = voltage.global;



end

