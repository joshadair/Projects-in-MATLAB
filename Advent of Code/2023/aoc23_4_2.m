function [cards,winners]=aoc23_4_2(wins,picks)
[row,col]=size(wins);
winners=zeros(row,col);
for i1=1:row
    aWins=wins(i1,:);
    aPicks=picks(i1,:);
    numWins=0;

    for i2=1:col
        num=aWins(i2);

        if ismember(num,aPicks)==1
            numWins=numWins+1;
        end

    end

    if numWins>0
        count=1;
        for i3=i1+1:i1+numWins
            winners(i1,count)=i3;
            count=count+1;
        end
    end
end

cards=winners(1,:);
for i1=2:row
    copies=sum(cards==i1)+1;
    for i2=1:copies 
        cards=[cards winners(i1,:)];
    end
end
cards(cards==0)=[];
cards=[1:row cards];

end



%{
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
%}