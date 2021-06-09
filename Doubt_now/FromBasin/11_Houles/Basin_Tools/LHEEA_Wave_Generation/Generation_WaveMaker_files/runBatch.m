%path_base = '.\';
path_base= 'D:\ownCloudData\Équipe Bassin\Projets_experimentaux\Projets_2018\1809_QualifHoule2018\02_Expérimentation\wmk';

for iCase = 11:13
    for scale= [20 30 50 62.4650 70 100]
    wmkHOS_2_wav(iCase,scale,path_base)
    end
end


for iCase = 21
    for scale = [20 30 50 70 100]
    wmkHOS_2_wav(iCase,scale, path_base)
    end
end

for iCase = 31
    for scale = [20 30 50 70 100]
    wmkHOS_2_wav(iCase,scale, path_base)
    end
end

for iCase = [111:113]
    for scale = [20 38.9728 40 80]
    wmkHOS_2_wav(iCase,scale,path_base)
    end
end


for iCase = [121:123]
    for scale = [20 40 80]
    wmkHOS_2_wav(iCase,scale,path_base)
    end
end

