function indices1= TimestepandIndicesEvaluation(Meshsize,Ux,Uy,Co,time)

%%%%U velocity given from the input waves are Ux,Uz%%%%%%%%
%%%%%Also Courant number is given from the testcase%%%%%%%%
%%% Relative velocity %%%%%%%%%%%%%%%%%%%%%%%%%%%

Ur=sqrt(Ux^2+Uy^2);
deltaT=Co*Meshsize/Ur; 

%%Indices of particular Time to be evaluated 
indices1=round(time/deltaT);

end

 


