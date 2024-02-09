function [counts,unique_mols]=aoc15_19_1(subs,base)
unique_mols={};
counts=[];
for i1=1:length(subs)
    findX=subs{i1,1};
    replaceX=subs{i1,2};

    locs=strfind(base,findX);

    if isempty(locs)==1
        counts=[counts;0];
        continue;
    else
        for i2=1:length(locs)
            new=[base(1:locs(i2)-1),replaceX,base(locs(i2)+length(findX):end)];
            unique_mols{end+1}=new;
        end
        counts=[counts;length(locs)];
    end
end
unique_mols=unique_mols';
end
