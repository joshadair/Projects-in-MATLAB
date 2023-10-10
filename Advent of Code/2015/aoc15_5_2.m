function [naughty,nice]=aoc15_5_2(input)
naughty=[];
nice=[];

for idx1=1:numel(input)
    trigger1=0;
    nice1=0;
    nice2=0;
    test=input{idx1};

    for idx2=1:length(test)-1
        if trigger1==1
            break;
        end

        for idx3=1:length(test)-1
            if idx2~=idx3 && idx2~=idx3-1 && idx3~=idx2-1 && strcmp(test(idx2:idx2+1),test(idx3:idx3+1))==1   
                nice1=1;
                trigger1=1;
                break
            end
        end
    end

    if nice1==1
        for idx4=1:length(test)-2
            if test(idx4)==test(idx4+2)
                nice2=1;
                break
            end
        end
    end

    if nice1==1 && nice2==1
        nice=[test;nice];
    else
        naughty=[test;naughty];
    end
end

end
