function o=aoc23_1_1(in)
o=[];

for i1=1:1000
    active=char(in(i1));
    num='';
    for i2=1:numel(active)
        if ismember(active(i2),['1','2','3','4','5','6','7','8','9'])==1
            num=[num active(i2)];
            break;
        end
    end

    for i3=numel(active):-1:1
        if ismember(active(i3),['1','2','3','4','5','6','7','8','9'])==1
            num=[num active(i3)];
            break;
        end
    end
    o=[o;num];
end
end
