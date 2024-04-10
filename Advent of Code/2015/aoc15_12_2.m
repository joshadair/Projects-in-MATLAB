function [open,close,objects,strings,parents]=aoc15_12_2(in)
open=[];
unclosed=[];
close=[];
objects={};
strings=[];
parents=[];
parent=1;
child=1;
for i1=1:length(in)
    if in(i1)=='{'
        open(end+1)=i1;
        if  isempty(close)==1 || max(open)>max(close)
            unclosed(end+1)=i1;
        end
    elseif in(i1)=='}'
        close(end+1)=i1;
        if length(close)==length(open)
            objects{end+1}=[unclosed(end),close(end),"parent"+parent,child-1,"-",in(unclosed(end):close(end))];
            parents(end+1)=size(objects,1);
            parent=parent+1;
            child=1;
            unclosed(end)=[];
        elseif length(close)<length(open)
            if size(objects,1)>1 && unclosed(end)<str2double(objects(end-1,1))
                objects{end+1}=[unclosed(end),close(end),child+"childof"+parent,"parentofprev","-",in(unclosed(end):close(end))];
                parents(end+1)=size(objects,1);
                for i2=1:size(objects,1)
                    if str2double(objects(i2,1))>str2double(objects(end,1))
                        objects(i2,3+i2)="childof"+(size(objects,1));
                    end
                end
            else
                objects{end+1}=[unclosed(end),close(end),child+"childof"+parent,"-","-",in(unclosed(end):close(end))];
            end
            child=child+1;
            unclosed(end)=[];
        end


        
    end
end
%{
for i1=1:length(objects)
    s=char(objects(i1,6));
    n=sum(ismember(s,'{'));
    while n>1
        last_open=find(s=='{',1,'last');
        next_close=last_open+find(s(last_open:end)=='}',1,'first')-1;
        s(last_open:next_close)='';
        n=sum(ismember(s,'{'));
    end
    objects(i1,7)=s;
    if contains(s,"red")==1
        objects(i1,8)="1";
    else
        objects(i1,8)="0";
    end
end
%}
objects=objects';

end