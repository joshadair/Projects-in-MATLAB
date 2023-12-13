function counts=aoc23_4_1(wins,picks,start)
counts=zeros(length(wins),1);
while start<=length(wins)
    aWins=wins(start,:)';
    aPicks=picks(start,:)';
    numWins=0;
    for i1=1:length(aWins)
        aWin=aWins(i1);
        if ismember(aWin,aPicks)==1
            numWins=numWins+1;
        end
    end

     if numWins>0
        for i1=1:counts(start)
            for i2=1:numWins-1
            counts(start+i2)=counts(start+i2)+1;
            end
        end
    end

    for i1=0:numWins-1
        counts(start+i1)=counts(start+i1)+1;
    end

   

    start=start+1;
end

end