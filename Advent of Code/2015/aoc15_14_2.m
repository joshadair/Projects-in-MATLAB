function stats=aoc15_14_2(in)
% holder matrix for each reindeer [fly_time, rest_time, dist, points]
stats=zeros(length(in),4);

for i1=1:length(in);
    stats(i1,2)=in(i1,3);
end

for counter=1:2503
    for i1=1:length(in)
        if stats(i1,2)<in(i1,3)
            stats(i1,2)=stats(i1,2)+1;
            continue;
        else
            stats(i1,3)=stats(i1,3)+in(i1,1);
            stats(i1,1)=stats(i1,1)+1;
        end

        if stats(i1,1)==in(i1,2)
            stats(i1,2)=0;
            stats(i1,1)=0;
        end
    end
    [~,loc]=max(stats(:,3));
    stats(loc,4)=stats(loc,4)+1;
end
end
