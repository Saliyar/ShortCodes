function ResAna=dofilterandfftOnSignal(time, data, filterState, f1, f2,info, nPeriod)
staticFFT = false;

[DataFiltered] = POMAP_freq_filter([time data], 'butter', filterState, f1, f2, 2, 1);

ResAna.DataFiltered = DataFiltered(:,2:end);
% 
for iVar=1:size(data,2) 

    f_samp  = 1 / (time(2) - time(1));
    N1period = info.Ttheo /(time(2) - time(1));
    
    for iPeriod = 1:(length(time)/N1period)
        ibegin = round(1+(iPeriod-1)*N1period)
        II{iPeriod} = ibegin:(ibegin+N1period-1);
        MaxDataEachPeriod(iPeriod) = max(data(II{iPeriod},iVar));
        MinDataEachPeriod(iPeriod) = min(data(II{iPeriod},iVar));
    end
        ResAna.MaxDataFiltered(1,iVar) = mean(MaxDataEachPeriod); % We could add std
        ResAna.MinDataFiltered(1,iVar) = mean(MinDataEachPeriod);
    
    %[u , d] = wbw_analysis(time,data(:,iVar));
%     up(ich) = u;
%     down(ich) = d;
%     avg(ich)=mean(up(ich).H(1:end-1));
%     mini(ich) = min(up(ich).H(1:end-1));
%     maxi(ich) =  max(up(ich).H(1:end-1));
%     avgCrest(ich)=mean(up(ich).crest(1:end-1));
    
end


ResAna.MaxDataFilteredALL=max(ResAna.DataFiltered);   % Data
ResAna.MinDataFilteredALL=min(ResAna.DataFiltered);  % Data
ResAna.MaxData=max(data);   % Data
ResAna.MinData=min(data);  % Data

if staticFFT
    [fData, y_absData] =  FFTMatrix(data,Fs);
    ResAna.fData = fData;
    ResAna.y_absData = y_absData;
    
    
    [Data1st, DataFreq1st] = findValMaxFFT(ResAna.fData, ResAna.y_absData);
    ResAna.Data1st = Data1st ; 
    ResAna.DataFreq1st = DataFreq1st;
else
    sfft = sfftHarmonic(time ,data, info.Ttheo);
    ResAna.timeSfft=sfft(1).time;
    
    for iVar=1:size(data,2) 
    ResAna.DataSfft0{iVar} = sfft(iVar).harmonicZero;
    ResAna.DataSfft1{iVar} = sfft(iVar).fftabs(:,1);
    ResAna.DataSfft2{iVar} = sfft(iVar).fftabs(:,2);
    end
    
    sfft = sfftHarmonic(time , data, info.Ttheo, 5, nPeriod, 1);
    for i = 1:length(sfft)
        ResAna.sfftAbsData0(i) = sfft(i).harmonicZero;
        ResAna.sfftAbsData1(i) = sfft(i).fftabs(1);
        ResAna.sfftAbsData2(i) = sfft(i).fftabs(2);
    end
    ResAna.Data0th = ResAna.sfftAbsData0;
    ResAna.Data1st = ResAna.sfftAbsData1;  % last probe is reference
    ResAna.Data2nd = ResAna.sfftAbsData2;
    ResAna.DataFreq1st = 1./info.Ttheo;
     clear sfft;    
     
end