function PROJPlotReportGraphs(varargin)
%function of class PROJ
%Reads the result file and plot the frequency data.
%Syntax :
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... })
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },[freqWindow])
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },'pdf')
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },'pdf',[freqWindow])
%PROJPlotReportGraphs(proj,{testlist1,testlist2, ... },[freqWindow],'pdf')
%{testlist1,testlist2, ... } : cell array of testlists, one for each
%configuration

%testing input arguments--------------------------------------------------
%-------------------------------------------------------------------------
switch nargin
case 2
    if (isa(varargin{1},'project') && isa(varargin{2},'cell'))
        p = varargin{1}; %Initialisation of test
        printarg = 0;
        freqmin=1/5;
        freqmax=2;
        testlist=varargin{2};        
    else
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end    
case 3    
     if (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{3},'double'))
        p = varargin{1};   %Initialisation of test
        printarg = 0;
        fr1=varargin{3};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
        
     elseif (isa(varargin{1},'project') && isa(varargin{2},'cell') && ischar(varargin{3}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{3},'pdf');
        freqmin=1/5;
        freqmax=2;
        testlist=varargin{2};
     else    
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end
        
case 4    
    if (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{3},'double') && ischar(varargin{4}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{4},'pdf');
        fr1=varargin{3};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
        
     elseif (isa(varargin{1},'project') && isa(varargin{2},'cell') && isa(varargin{4},'double') && ischar(varargin{3}))
        p = varargin{1};   %Initialisation of test
        printarg = strcmp(varargin{3},'pdf');
        fr1=varargin{4};
        freqmin=fr1(1);
        freqmax=fr1(2);
        testlist=varargin{2};
     else    
        error('1st argument is not a test object and/or 2nd argument is not a cell array');
    end
    
end

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

tex = sprintf('Plotting RAOs - Project : %s',get(p,'name'));
disp(tex);

%On parcourt les listes d'essais une par une ------------------------------
%--------------------------------------------------------------------

    for iconfig=1:length(testlist)  
        numtest=cell2mat(testlist(iconfig));  
    %On parcourt les tests de la premiere liste
        for itest=numtest 
            t=test(p,itest)
            
        
        end
 
end

end


