function steps=aoc15_19_2(subs,base)
steps=1;
active=[];
new={};
start='e';

matches=[];
for i1=1:length(subs)
    if strcmp(subs{i1,1},start)==1
        matches=[matches;i1];
    end
end



while strcmp(active,base)==0


    for i1=1:length(matches)
        add=subs{matches(i1),2};
        new{steps,end+1}=[active add];

    end



steps=steps+1;

end






end