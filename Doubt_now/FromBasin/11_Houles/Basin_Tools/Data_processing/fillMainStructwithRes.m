function ResFull=fillMainStructwithRes(ResFull, ResAna,CodeStr)
field = {'DataFiltered', 'MaxDataFiltered','MinDataFiltered', 'MaxData','MinData','timeSfft', ...
    'DataSfft0','DataSfft1','DataSfft2','Data0th','Data1st','Data2nd','DataFreq1st'};

for i = 1:length(field)
    eval(['ResFull.', strrep(field{i},'Data',CodeStr),'= ResAna.',field{i}]); 
end 

end