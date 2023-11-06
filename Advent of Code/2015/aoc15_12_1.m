function out=aoc15_12_1(in)
out=[];
temp=[];
for i1=1:length(in)
    if sum(ismember(in(i1),['0','1','2','3','4','5','6','7','8','9']))>0
        if in(i1-1)=='-'
            temp=[temp -1 (in(i1)-'0')];
        else
            temp=[temp in(i1)-'0'];
        end
    else
        if isempty(temp)==1
            continue;
        else
            if temp(1)==-1
                out=[out;-1*polyval(temp(2:end),10)];
                temp=[];
            else
                out=[out;polyval(temp,10)];
                temp=[];
            end
        end
    end
end
end

