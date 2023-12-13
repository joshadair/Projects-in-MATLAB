function [out,hands,bids]=aoc23_7_1(in)
out=in;
fives={};
fours={};
fullhouse={};
threes={};
twopair={};
onepair={};
highcard={};

% classify all hands by type and group
for i1=1:length(in)
    hand=char(string(in{i1,1}));
    handV=hand-'0';
    handV=handV';
    bid=in{i1,2};

    [counts,~]=groupcounts(handV);

    if counts==5
        out{i1,3}='5';
        fives{end+1,1}=hand;
        fives{end,2}=bid;
    elseif max(counts)==4
        out{i1,3}='4';
        fours{end+1,1}=hand;
        fours{end,2}=bid;
    elseif length(counts)==2 && all(sort(counts)==[2;3])==1
        out{i1,3}='FH';
        fullhouse{end+1,1}=hand;
        fullhouse{end,2}=bid;
    elseif length(counts)==3 && all(sort(counts)==[1;1;3])==1
        out{i1,3}='3';
        threes{end+1,1}=hand;
        threes{end,2}=bid;
    elseif length(counts)==3 && all(sort(counts)==[1;2;2])==1
        out{i1,3}='2P';
        twopair{end+1,1}=hand;
        twopair{end,2}=bid;
    elseif length(counts)==4 && all(sort(counts)==[1;1;1;2])==1
        out{i1,3}='1P';
        onepair{end+1,1}=hand;
        onepair{end,2}=bid;
    elseif max(counts)==1
        out{i1,3}='HC';
        highcard{end+1,1}=hand;
        highcard{end,2}=bid;
    end
end


[sorted5Hands,sorted5Bids]=sortedTypes(fives);
[sorted4Hands,sorted4Bids]=sortedTypes(fours);
[sortedFHHands,sortedFHBids]=sortedTypes(fullhouse);
[sorted3Hands,sorted3Bids]=sortedTypes(threes);
[sorted2PHands,sorted2PBids]=sortedTypes(twopair);
[sorted1PHands,sorted1PBids]=sortedTypes(onepair);
[sortedHCHands,sortedHCBids]=sortedTypes(highcard);

% function sorts typed groups based on strong card

    function [sortedHands,sortedBids]=sortedTypes(in)
        cardRanks=['A' 'K' 'Q' 'J' 'T' '9' '8' '7' '6' '5' '4' '3' '2'];
        cardVals=[13  12  11  10  9   8   7   6   5   4   3   2   1];
        trigger=0;
        sortedHands=[];
        sortedBids=[];

        while isempty(in)==0
            aSet=in(1,:);
            aHand=aSet{1,1};
            aBid=aSet{1,2};

            if isempty(sortedHands)==1
                sortedHands=[sortedHands;aHand];
                sortedBids=[sortedBids;aBid];
                in(1,:)=[];
            else

                [row,col]=size(sortedHands);
                for i1=1:row
                    if trigger==1
                        trigger=0;
                        break
                    end

                    cHand=sortedHands(i1,:);

                    for i2=1:5
                        aCard=aHand(i2);
                        aVal=cardVals(cardRanks==aCard);
                        cCard=cHand(i2);
                        cVal=cardVals(cardRanks==cCard);

                        if aVal>cVal
                            sortedHands=[sortedHands(1:i1-1,:);aHand;sortedHands(i1:end,:)];
                            sortedBids=[sortedBids(1:i1-1,:);aBid;sortedBids(i1:end,:)];
                            trigger=1;
                            in(1,:)=[];
                            break
                        elseif aVal<cVal
                            if i1==row
                                sortedHands=[sortedHands;aHand];
                                sortedBids=[sortedBids;aBid];
                                in(1,:)=[];
                            end
                            break
                        end
                    end
                end
            end
        end

    end

hands=[sorted5Hands;sorted4Hands;sortedFHHands;sorted3Hands;sorted2PHands;sorted1PHands;sortedHCHands];
bids=[sorted5Bids;sorted4Bids;sortedFHBids;sorted3Bids;sorted2PBids;sorted1PBids;sortedHCBids];

end
