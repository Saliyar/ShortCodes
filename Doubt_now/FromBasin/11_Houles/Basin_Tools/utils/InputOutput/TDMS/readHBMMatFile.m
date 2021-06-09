function Sig = readTDMSFile(pathHBM,labelHBMMat,GoodChannels, LegendChannels)
%label = 'SARAH-DRY_016'  
filename = [labelHBMMat   '_19200Hz.MAT'];
filename2 = [labelHBMMat '_200Hz.MAT'];


Sig1 = ReadFiles_QUANTUM_CATMAN_MATLAB_WithIssues(pathHBM, filename);
Sig2 = ReadFiles_QUANTUM_CATMAN_MATLAB_WithIssues(pathHBM, filename2);

if nargin>4
    TestName=1;
else
    TestName =0;
    GoodChannels='';
end


%         if (~isempty(find(strcmp(names_t{k},GoodChannels), 1)) || TestName ==0) % check if we keep this channel
%             indExcel = find(strcmp(names_t{k},GoodChannels), 1);
% 
% 
% 
%             kk=kk+1;
%             names{kk} =names_t{k};
%             legend_names{kk} =names_t{k};
% 
%             if ~isempty(LegendChannels{indExcel})
%              legend_names{kk}  = LegendChannels{indExcel};
%             end
% 
% %             display(names_t{k});
% %             display(legend_names{kk});
% 
%             Sig{iSampFound}.dataa =[ Sig{iSampFound}.dataa temp.data{iCh}'];
%             cleanName =cleanString(names{kk},{'-', ' ','[',']'});
% 
%             eval(['Sig{iSampFound}.II_' cleanName  '=kk;']); % index of the channel
%         end
% 
% 
%     if (max(deltaT)==min(deltaT))
%         Sig{iSampFound}.time = [1:C(iSampling)]'*deltaT(1);
%         Sig{iSampFound}.names=names;
%         Sig{iSampFound}.legend_names =  legend_names;
%         %Sig{iSampFound}.II =JJ;
%     else
%         error('DeltaT are not the same in the channels grouped together');
%     end
%     clear names_t deltaT
end
