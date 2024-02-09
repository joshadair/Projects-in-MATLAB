function [arrangements,matches]=aoc23_12_1(record,pattern)
matches=0;
total=sum(pattern);
slots=length(record);

N=slots;k=total;
v=1:N;
C1=nchoosek(v,k);%find rows that should be 1
C2=repmat((1:size(C1,1))',1,size(C1,2));%find the column indices
out=accumarray([C1(:) C2(:)],ones(numel(C1),1));%fill a zero matrix
out=out';
arrangements={};

for index=1:length(out)
    arrangements{end+1}=getPattern01s(out(index,:));
end

for index=1:length(arrangements)
    test=arrangements{index};
    if isequal(test,pattern)==1
        matches=matches+1;
    end
end




    function o=getPattern01s(in)
        count=1;
        o=[];
        for i1=1:length(in)-1
            if in(i1+1)==in(i1)
                count=count+1;
            else
                o=[o;count];
                count=1;
            end

            if in(i1+1)==in(i1) && i1==(length(in)-1)
                o=[o;count];
            end
        end
    end
end
