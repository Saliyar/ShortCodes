function Sig = readTDMSFile(pathTDMS,fileTDMS,GoodChannels, LegendChannels)

if nargin==4
    TestName=1;
else
    TestName =0;
    GoodChannels='';
end

temp          = TDMS_readTDMSFile(fullfile(pathTDMS,fileTDMS));
%  [output,nav]  = TDMS_dataToGroupChanStruct_v2(temp);

[C,~,IC] =  unique(temp.numberDataPointsRaw); % Look number different frequencies
II = find(C > 0 );
iSampFound=0;
for iSampling=II
    iSampFound = iSampFound +1;
    Indexi = find (IC == iSampling);
    Sig{iSampFound}.dataa =[];
    kk=0;
    for k = 1:length(Indexi) % cycle over indexes of same frequency
        iCh = Indexi(k);
        wesh =temp.propValues{1,iCh};
        iName = strcmp(temp.propNames{iCh},'NI_ChannelName');
        names_t{k}= wesh{iName}; % this is the name of the channel


        iDt = strcmp(temp.propNames{iCh},'wf_increment');
        deltaT(k) = wesh{iDt};  % this is the delta t of the channel
        if (~isempty(find(strcmp(names_t{k},GoodChannels), 1)) || TestName ==0) % check if we keep this channel
            indExcel = find(strcmp(names_t{k},GoodChannels), 1);



            kk=kk+1;
            names{kk} =names_t{k};
            legend_names{kk} =names_t{k};

            if ~isempty(LegendChannels{indExcel})
             legend_names{kk}  = LegendChannels{indExcel};
            end

%             display(names_t{k});
%             display(legend_names{kk});

            Sig{iSampFound}.dataa =[ Sig{iSampFound}.dataa temp.data{iCh}'];
            cleanName =cleanString(names{kk},{'-', ' ','[',']'});

            eval(['Sig{iSampFound}.II_' cleanName  '=kk;']); % index of the channel
        end

    end

    if (max(deltaT)==min(deltaT))
        Sig{iSampFound}.time = [1:C(iSampling)]'*deltaT(1);
        Sig{iSampFound}.names=names;
        Sig{iSampFound}.legend_names =  legend_names;
        %Sig{iSampFound}.II =JJ;
    else
        error('DeltaT are not the same in the channels grouped together');
    end
    clear names_t deltaT
end
