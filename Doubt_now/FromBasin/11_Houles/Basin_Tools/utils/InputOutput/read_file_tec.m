function [Th] = read_file_tec(varargin)

switch nargin
    case 2
        filin=varargin{1};
        namezone=varargin{2};
    case 1
        filin=varargin{1};
end

idfilin=fopen(filin);
if (idfilin == -1)
    fprintf('WARNING!!!! file Carro non valido');
    pause
end


premierlign=fgetl(idfilin);
while strcmp(premierlign(1),'#')
premierlign=fgetl(idfilin);    
end

Position= strfind(premierlign, 'TITLE');
if size(Position,2)>0
premierlign=fgetl(idfilin);
end
premierlign2=strrep(premierlign,',','');
premierlign2=strrep(premierlign2,'/','_div_');
premierlign2=strrep(premierlign2,'*','_per_');
premierlign2=strrep(premierlign2,'%','percent');
premierlign2=strrep(premierlign2,'''','');


[a] = strread(premierlign2, '%s', 'delimiter', '"');

i=1;

for k=2:size(a,1)
    if (strcmp('',a(k))==0 & strcmp(',',a(k))==0)
        lign(i)=a(k);
        i=i+1;
    end
    k=k+1;
end
%%%%%%%%%%%5
%%stabilimento del numero canale
nch=size(lign,2);
formato = '%g ';
for i=1:nch-1
    formato = [formato '%g '];
end
switch nargin
    case 2
        for  j=1:nzone

            namezone=fgetl(idfilin);
            Position= strfind(namezone, '"');

            [namezone2] = strread(namezone, '%s', 'delimiter', '"');

            clear namezone

            expression_zone=strcat('Th{',num2str(j),'}.Namezone=namezone2(2);');
            eval(expression_zone);


            sig=fscanf(idfilin,formato,[nch inf]);

            for i=1:nch
                i;
                nome=char(lign(i));
                expression=strcat('Th{',num2str(j),'}.',nome,'=sig(',num2str(i),',:);');
                eval(expression);
            end
            clear sig
        end
    case 1
        vatene =1;
        j=0;
        while vatene
            j=j+1;
            namezone=fgetl(idfilin);
            if size(namezone,2)>4
                if strfind(premierlign, 'ZONE')
                Position= strfind(namezone, '"');

                [namezone2] = strread(namezone, '%s', 'delimiter', '"');

                clear namezone

                expression_zone=strcat('Th{',num2str(j),'}.Namezone=namezone2(2);');
                eval(expression_zone);
                end

                sig=fscanf(idfilin,formato,[nch inf]);

                for i=1:nch
                    i;
                    nome=char(lign(i));
                    expression=strcat('Th{',num2str(j),'}.',nome,'=sig(',num2str(i),',:);');
                    eval(expression);
                end
                clear sig
            else
                vatene=0;
            end
        end

end

return