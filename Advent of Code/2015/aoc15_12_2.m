function [open,close,objects,strings,parents,redsnoreds] = aoc15_12_2(in)
open=[];
unclosed=[];
close=[];
objects=[];
strings=[];
parents=[];
parent=1;
child=1;
for i1=1:length(in)
    if in(i1)=='{'
        open=[open;i1];
        if  isempty(close)==1 || max(open)>max(close)
            unclosed=[unclosed;i1];
        end
    elseif in(i1)=='}'
        close=[close;i1];
        if length(close)==length(open)
            objects=[objects;unclosed(end),close(end),"parent"+parent,"-"];
            parents=[parents;length(objects)];
            parent=parent+1;
            child=1;
            unclosed(end)=[];
            % elseif length(burly)==length(curly) && isempty(unclosed)==1
            %    groups=[groups;curly(end),burly(end),"2"];
        elseif length(close)<length(open)
            groups_size=size(objects);
            if groups_size(1)>1 && unclosed(end)<str2double(objects(end-1,1))
                objects=[objects;unclosed(end),close(end),child+"childof"+parent,"parentofprev"];
                for i2=1:groups_size(1)
                    if str2double(objects(i2,1))>str2double(objects(end,1))
                        objects(i2,4)="childof"+(groups_size(1)+1);
                    end
                end
            else
                objects=[objects;unclosed(end),close(end),child+"childof"+parent,"-"];
            end
            child=child+1;
            unclosed(end)=[];
        end
    end
end

for i1=1:length(objects)
    strings=[strings;string(in(str2double(objects(i1,1)):str2double(objects(i1,2)))),"-","0"];

    s=char(strings(i1,1));
    n=sum(ismember(s,'{'));
    while n>1
        last=find(s=='{',1,'last');
        first=last+find(s(last:end)=='}',1,'first')-1;
        s(last:first)='';
        n=sum(ismember(s,'{'));
    end
    strings(i1,2)=s;

    if contains(s,"red")==1
        strings(i1,3)="1";
    end
end

for i1=1:length(objects)
    if contains(objects(i1,3),"child")==1
        temp=char(objects(i1,3));
        if temp(end-1)=="f"
            temp=temp(end);
        else
            temp=temp(end-1:end);
        end

        if strings(parents(str2double(temp)),3)=="1"
            strings(i1,3)="1";
        end
    end
end

for i1=1:length(objects)
    if contains(objects(i1,4),"child")==1
        temp=char(objects(i1,4));
        if temp(end-1)=="f"
            temp=temp(end);
        else
            temp=temp(end-1:end);
        end

        if strings(str2double(temp),3)=="1"
            strings(i1,3)="1";
        end
    end
end

redsnoreds=[];
for i1=1:length(objects)
    if strings(i1,3)=="0"
        redsnoreds=[redsnoreds;0,sum(aoc15_12_1(char(strings(i1,2))))];
    else
        redsnoreds=[redsnoreds;1,sum(aoc15_12_1(char(strings(i1,2))))];
    end
end



end

%{
for i1=1:length(strings)
    active=char(strings(i1));
    edited="";
    locs_open=strfind(active,"{");
    locs_close=strfind(active,"}");
    if numel(locs_open)>1
        for i2=2:numel(locs_open)
            temp=strings(i1);
            edited=temp(locs_open(i2):locs_close(i2-1));
            temp(strfind(temp,edited),length(edited))="";

            
        end
        strings(i1,2)=edited;
    else
        strings(i1,2)=active;
    end

 

end

end

%}

