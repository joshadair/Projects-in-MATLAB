function [out,patterns,yes]=aoc23_12_1b(record,groups,allcombs)
out=[];
q=find(record=='?');
n=length(q);
combs=allcombs{n};
groups(isnan(groups))=[];

[row,col]=size(combs);
for i1=1:row
    a=combs(i1,:);
    temp=record;
    for i2=1:n
        if a(i2)==1
            temp(q(i2))='#';
        else
            temp(q(i2))='.';
        end
    end
    out=[out;temp];
end

patterns={};
[row,col]=size(out);
for i1=1:row
    p=hashPat(out(i1,:));
    patterns{end+1}=p;
end
patterns=patterns';


yes=0;
l=length(groups);
for i1=1:length(patterns)
    if length(patterns{i1})==l && all(patterns{i1}==groups)
        yes=yes+1;
    end
end


    function out=hashPat(in)
        out=[];
        count=0;
        for i1=1:length(in)
            if in(i1)=='#'
                count=count+1;
            else
                if count~=0
                    out(end+1)=count;
                end
                count=0;
            end
        end
        if count~=0
            out(end+1)=count;
        end
    end


end