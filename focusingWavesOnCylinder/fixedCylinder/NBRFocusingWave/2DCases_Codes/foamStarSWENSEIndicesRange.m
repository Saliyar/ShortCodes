function IndicesforTimeinterval=foamStarSWENSEIndicesRange(dt_foamStar,Meshsize,Ux,Uy,Co,dataNotedforTimestep)


if(any(dt_foamStar>37)==1)
    5
	starttime=37;endtime=42;
	foamStarIndices1=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,starttime,dataNotedforTimestep);
	foamStarIndices2=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,endtime,dataNotedforTimestep);
	foamStarIndices=foamStarIndices1:foamStarIndices2;

else
	6
	starttime=0.01;endtime=5;
	foamStarIndices1=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,starttime,dataNotedforTimestep);
	foamStarIndices2=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,endtime,dataNotedforTimestep);
	foamStarIndices=foamStarIndices1:foamStarIndices2;
end
IndicesforTimeinterval=foamStarIndices;

end
