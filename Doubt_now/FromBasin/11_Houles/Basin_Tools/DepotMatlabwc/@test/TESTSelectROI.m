function TESTSelectROI(varargin)

%function of class TEST
%Enable Region of Interest Selection with cursor on the graph
%Syntax :
%TestSelectROI(test,channel)

%testing input arguments--------------------------------------------------
switch nargin
case 1 
    if isa(varargin{1},'test')
        te = varargin{1};   
        channel = 1;
    else
        error('1st argument is not a test object');
    end
case 2
    if isa(varargin{1},'test')
       if isa(varargin{2},'double') 
        te = varargin{1};   
        channel = 1;
       else
            error('wrong printing argument');
       end
    else
        error('1st argument is not a test object');
    end   
end

tex = sprintf('Selection of region of interest n°1 - Project : %s - Test n°%d ...',get(te,'name'),get(te,'num'));
disp(tex);

%creation et affichage du signal -----------------------------------------
sig = signal(te,channel);
plot(sig);

[x,y] = ginput(2);

ROI = [x,y]

tex = sprintf('\b Done');
disp(tex);

end