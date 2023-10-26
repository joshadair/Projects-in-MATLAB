function out = aoc15_16_1(in,tape_name,tape_value)

for i1=1:length(in)
    for i2=2:2:6
        name=in{i1,i2};
        val=in{i1,i2+1};
        if strcmp(name,"cats")==1 || strcmp(name,"trees")==1
            if val<=tape_value(tape_name==name)
                break;
            else
                if i2==6
                    out=i1;
                    return;
                else
                    continue;
                end
            end

        elseif strcmp(name,"pomeranians")==1 || strcmp(name,"goldfish")==1
            if val>=tape_value(tape_name==name)
                break;
            else
                if i2==6
                    out=i1;
                    return;
                else
                    continue;
                end
            end
        elseif val==tape_value(tape_name==name)
            if i2==6
                out=i1;
                return;
            else
                continue;
            end
        else
            break;
        end
    end
end
end