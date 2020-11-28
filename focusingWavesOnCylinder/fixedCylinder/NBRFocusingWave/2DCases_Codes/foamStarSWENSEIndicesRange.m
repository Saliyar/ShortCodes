function IndicesforTimeinterval=foamStarSWENSEIndicesRange(dt_foamStar,Meshsize,Ux,Uy,Co,starttime)


if(any(dt_foamStar>37)==1)
	starttime=37;endtime=42;
	foamStarIndices1=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,starttime);
	foamStarIndices2=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,endtime);
	foamStarIndices=foamStarIndices1:foamStarIndices2;

else
	
	starttime=0.01;endtime=5;
	foamStarIndices1=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,starttime);
	foamStarIndices2=TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,endtime);
	foamStarIndices=foamStarIndices1:foamStarIndices2;
end
IndicesforTimeinterval=foamStarIndices;

end
