function points=aoc23_4_1(wins,picks)
points=zeros(length(picks),1);

for i1=1:length(wins)
    aWins=wins(i1,:);
    aPicks=picks(i1,:);
    numWins=0;

    for i2=1:length(aWins)
        num=aWins(i2);

        if ismember(num,aPicks)==1
            numWins=numWins+1;
        end

    end

    if numWins==0
        points(i1)=0;
    else
        points(i1)=2^(numWins-1);
    end
end

end

