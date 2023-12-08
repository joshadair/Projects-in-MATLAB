function [r,g,b]=aoc23_2_1(in)
r=0;
g=0;
b=0;

game=split(in,':');
rounds=split(game{2},';');

for i1=1:numel(rounds)
    active=split(rounds{i1},',');

    for i2=1:numel(active)
        draw=split(active{i2});
        count=str2double(draw{2});
        switch draw{3}
            case 'red'
                if count>r
                    r=count;
                end
            case 'green'
                if count>g
                    g=count;
                end
            case 'blue'
                if count>b
                    b=count;
                end
        end
    end
end

end