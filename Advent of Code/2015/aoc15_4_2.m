function [naughty,nice]=aoc15_5_1(input);
naughty=[];
nice=[];

for idx1=1:numel(input)
    trigger1=0;
    test=input{idx1};

    if length(intersect(test,'aeiou'))<=2
        naughty=[test;naughty];
        continue
    end

    for idx2=1:length(test)-1
        if test(idx2)==test(idx2+1)
           naughty=[test;naughty];
           trigger1=1;
           break
        end
    end

    if trigger1==1
        continue;
    end

    if ismember(['ab','cd','pq','xy'],test)==1
        naughty=[test;naughty];
        continue
    end

    nice=[test;nice];
end

end


