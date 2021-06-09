function  ReadFiles_qualisys_motions_global_data(varargin)

% This function loads the catman files and store the data in a global
% variable
if nargin == 0
    [filename, pathname] = uigetfile( ...
{  '*.log;*.dat;*.tsv;*.txt','log files; dat files; tsv files;txt files (*.log,*.dat,*.tsv)'; 
    '*.log', 'log file (*.log)';...
    '*.dat','dat-file (*.dat)'; ...
    '*.tsv','tsv-file (*.tsv)'; ...
    '*.txt','txt-file (*.txt)';  ...
    '*.*',  'All Files (*.*)'}, ...
   'Select Qualisys Motions Files  ', ...
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
data.file.analog = 2;



data.voltage.voltage_1 = voltage_1;
data.time.time = time;
data.probes = probes;






