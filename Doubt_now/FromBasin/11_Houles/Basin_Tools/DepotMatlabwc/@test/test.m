function t = test(varargin)
% TEST class constructor.
%create an object of class TEST which fields are
%- p : the project from which it inherits the fields and methods
%- num :  the number of the test
%- fileMeas : the corresponding measurement file (path+ name)
%- fileRes : the corresponding results file (path+name) binary matlab file
%- channelNames{} : name of each measurement channel
%- channelUnits{} : unit of each measurement channel
%- channelGroups : define the groups of channels to be displayed together
%
%The builder prototype
% t = test(project,number)
switch nargin
case 0 
   % if no input arguments, create a default object
   t.num = 0;
   t.fileMeas = [];
   t.fileRes = [];
   t.channelNames = [];
   t.channelUnits = [];
   t.channelGroups = [];
   t.channelGroupsFreq = [];
   t.paramNames = {};
   t.paramNum = [];
   t.paramStr = {};
   %t.paramPostPro=[];
   t.paramPostProNum = []; %set the numerical parameters 
   t.paramPostProNames=[];

   p = project();
   t = class(t,'test',p);    
   
case 1
   % if single argument of class test, return it
   if (isa(varargin{1},'test'))
      t = varargin{1}; 
%    else
%       error('Input argument is not a test object')
   end
   
    t = class(t,'test',p);
   
case 2
   %create object using specified values   
   t.num = varargin{2};
   p = project(varargin{1});
   
   %Looking for the test corresponding to num in the test list
   %In the case one test would be missing...
   ls = get(p,'fileList');  %get the measurement file list
   for ki = 1:length(ls)        %browse the list
       name = ls{ki};           %extract file name
       nunum(ki) = str2num(name(end-6:end-4));  %extract num from file name
   end
   ind = find(nunum == t.num);  %find index corresponding to num
   
   t.fileMeas = [get(p,'pathMeas') ls{ind}];      %Set the file name
    
   %Building the .mat file
   nomf = ls{ind};                     %get the file name
   nomf(end-3:end) = ['.mat'];            %change the suffixe
   t.fileRes = [get(p,'pathRes') nomf];   %build the fichMat name
   
   %Loading the channels names and units
   [nu , tx] = xlsread([get(p,'path') 'testMatrix.xls'],'channelList');
   
   t.channelNames = tx(2:end,2);                %set the channelsName field
   t.channelUnits = tx(2:end,3);                %set the channelsUnit field
   t.channelGroups = num2cell(nu(1:end,4));     %set the channelsGroup field "ModifDLR"
   t.channelGroupsFreq= num2cell(nu(1:end,5));  %set the channelsGroup field "ModifDLR"
   
   %Loading the parameters 
   [nu , tx] = xlsread([get(p,'path') 'testMatrix.xls'],'testList');
   t.paramNames = tx(1,:); %set the parameters names (column names)
   ls = nu(:,1);
   ind = find(ls==t.num);
   t.paramNum = nu(ind,:); %set the numerical parameters
   t.paramStr = tx(ind+1,:); %set the string parameters  
   
   %Loading the post process parameters 
   [nu2 , tx2] = xlsread([get(p,'path') 'timeMatrix.xls'],'postProcess');
   %t.paramNames = tx(1,:); %set the parameters names (column names)
   ls2 = nu2(:,1);
   ind2 = find(ls2==t.num);
   t.paramPostProNum = nu2(ind2,2:end); %set the numerical parameters 
   t.paramPostProNames=tx2(1,2:end);
 
   t = class(t,'test',p);
   
otherwise
   error('Wrong number of input arguments')
end