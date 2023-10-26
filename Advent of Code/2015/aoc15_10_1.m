function o = aoc15_10_1(input);


for iter=1:50
    o=[];
    count=1;
    for i1=2:length(input)
        val=input(i1-1);
     
        if i1==length(input) && val==input(i1)
            o=[o count val];
        elseif i1==length(input) && val~=input(i1)
            o=[o count val 1 input(i1)];
        elseif val==input(i1)
            count=count+1;
            continue;
        else
            o=[o count val];
            count=1;
        end
    end
    prev_input=input;
    input=o;
end
