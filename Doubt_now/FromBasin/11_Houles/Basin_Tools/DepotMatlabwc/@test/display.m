function display(e)
% PROJET/DISPLAY Command window display of a projet
disp(['Test number: ' num2str(e.num)]);
disp(['Project : ' get(e,'name')]);
disp(['Measurement file name: ' e.fileMeas]);
disp(['Results file name: ' e.fileRes]);
nV = sprintf('MEASUREMENT CHANNELS :');
for k = 1 : length(e.channelNames)
    nV = sprintf('%s\n%d - ''%s'' in %s printed on board %d',nV,k,e.channelNames{k},e.channelUnits{k},e.channelGroups{k}); %"ModifDLR"
end
disp(nV);
para = sprintf('TEST PARAMETERS :');
paraN = get(e,'paramNames');
for k = 1 : length(paraN)
    %para = sprintf('%s\n%s',para,paraN(k));
    %para = sprintf('%s\n%d',para,e.param(k));
    %para = sprintf('%s\n%s = %5.1f',para,paraN{k},e.paramNum(k));
    para = sprintf('%s%s\n',para,paraN{k});
end
disp(para);
