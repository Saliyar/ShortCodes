function p = project(varargin)
%PROJECT project class constructor.
%create an object of class project which filds are :
%name : project name
%path : project path where all the files and folders are
%pathMeas : measurement files folder path
%pathRes : results files folder path
%pathFig :figures files folder path
%testList : cell array with measurement files names
%
%
%The builder prototypes
%p = project(name,path) 
%CAREFUL : a path ends with a \ !!!
switch nargin
case 0 
   p.name = [];
   p.path = [];
   p.pathMeas =  [];   
   p.pathRes = [];     
   p.pathFig = []; 
   p.fileList = []; 

   p = class(p,'project');
case 1
   if isa(varargin{1},'project')
        p = varargin{1};
   end

case 2        
   p.name = varargin{1};                %Definition of the name of the PROJECT/%on définit le nom du projet
   p.path = varargin{2};                %Definition of the PATH/%on définit le chemin
   if (exist([p.path 'Meas\'],'dir') == 7)
   p.pathMeas =  [p.path 'Meas\'];    %Path to the folder with the Measurements/%chemin du dossier Mesures
   else
   error(['''' [p.path 'Meas\'] ''' directory not found '])
   end
   if (exist([p.path 'Res\'],'dir') == 7)
   p.pathRes = [p.path 'Res\'];       %Path to the Analysis folder/%chemin du dossier Analyse
   else
   error(['''' [p.path 'Res\'] ''' directory not found '])
   end
   if (exist([p.path 'Fig\'],'dir') == 7)
   p.pathFig = [p.path 'Fig\'];       %Path to the Figure folder%chemin du dossier Figures
   else
   error(['''' [p.path 'Fig\'] ''' directory not found '])
   end
   
   d = dir(p.pathMeas);
   d(:).name;
   %Listing of the folder content /%On liste le contenu du dossier
   %d(1:3) = [];                         %Deletion of the 3 first elements /%On enleve les 3 premiers elements
   d(1:2) = [];
   for k = 1:length(d)
       p.fileList{k} = d(k).name;    %creation de la liste des nom de fichiers/% Creation of the file-name list
   end
   
   p = class(p,'project');
   
otherwise
   error('Wrong number of input arguments')
end
end

