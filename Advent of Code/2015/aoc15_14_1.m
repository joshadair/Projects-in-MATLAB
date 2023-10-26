function dist=aoc15_14_1(speed,duration,rest)
dist=0;
fly_time=0;
rest_time=rest;
for counter=1:2503
    if rest_time<rest
        rest_time=rest_time+1;
        continue;
    else
        dist=dist+speed;
        fly_time=fly_time+1;
    end

    if fly_time==duration
        rest_time=0;
        fly_time=0;
    end
end
end
