function ReadFiles_QUANTUM_CATMAN_Header_Global_data(varargin)
% This function loads the catman files and store the data in a global
% variable
if nargin == 0
    [filename , pathname, ~] = uigetfile( ...
        { '*.mat','mat-file (*.txt)'}, ...
        'Selectionner le fichier de mesure du QUANTUM CATMAN (.mat) ', ...
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

[time,probes,voltage ] = ReadFiles_QUANTUM_CATMAN_Header(pathname, filename);

%name probes
data.time.time = time;
data.probes = probes;
data.voltage.global = voltage.global;


end

