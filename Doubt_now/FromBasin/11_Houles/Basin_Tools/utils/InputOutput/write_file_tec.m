function varargout = Write_File_Tec_New2(file_uscita,Th,Namezone)

Names=fieldnames(Th);


premierlign='VARIABLES= ';
formato = '';
ii=0
for i=1:size(Names,1)
    
    eval(['SS=size(Th.', Names{i},');']);
    if (SS(2)~= max(SS))
        if (SS(2) ==1)
            ii=ii+1;
            expression=strcat('Matrix(ii,:)=Th.',Names{i},';');
            eval(expression);
            premierlign=strcat(premierlign,'"',Names{i},'"');
            
            formato=strcat(formato,' %d ');
            
        else  % We assume that the data is column...
            for j=1:SS(2)
                ii = ii +1;
                expression=strcat('Matrix(ii,:)=Th.',Names{i},'(:,j);');
                eval(expression);
                premierlign=strcat(premierlign,'"',Names{i},'_',num2str(j),'"');
                
                formato=strcat(formato,' %d ');
                
            end
            
        end
        
    else
        
        if (SS(1)==1 || SS(2)==1) % CAs normal
                ii=ii+1
            expression=strcat('Matrix(ii,:)=Th.',Names{i},';');
            eval(expression);
            premierlign=strcat(premierlign,'"',Names{i},'"');
            
            formato=strcat(formato,' %d ');
            
        else % We assume that the data is column...
            
            for j=1:SS(2)
                ii = ii +1;
                expression=strcat('Matrix(ii,:)=Th.',Names{i},'(:,j);');
                eval(expression);
                premierlign=strcat(premierlign,'"',Names{i},'_',num2str(j),'"');
                
                formato=strcat(formato,' %d ');
                
            end
            
        
        end
        
    end
    
end
formato=strcat(formato,'\n');
premierlign=strcat(premierlign,'\n');
Namezone=strcat('ZONE T="',Namezone,'"','\n');

file_uscita
premierlign
%%%Apertura del file
filout=fopen(file_uscita,'w');

fprintf(filout,premierlign);
fprintf(filout,Namezone);

%  expression='fprintf(filout,formato';
%
%  for i=1:size(Names,1)
%     expression=strcat(expression,',Matrix(',num2str(i),',j)');
%  end
%  expression=strcat(expression,');');
%
%  for j=1:size(Matrix,2)
%      eval(expression);
%  end


for j=1:size(Matrix,2)
    fprintf(filout,formato,Matrix(:,j));
end

fclose(filout)


return

