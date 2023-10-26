function happy_scores=aoc15_13_2(in)
p=perms(1:9);
happy_scores=[];
for i1=1:length(p)
    happy=0;
    active=p(i1,:);
    for i2=1:9;
        if i2>1 && i2 <9       
            happy=happy+in(active(i2),active(i2-1))+in(active(i2),active(i2+1));
        elseif i2==1
            happy=happy+in(active(i2),active(9))+in(active(i2),active(i2+1));
        elseif i2==9
            happy=happy+in(active(i2),active(1))+in(active(i2),active(i2-1));
        end       
    end
               happy_scores=[happy_scores;happy];
end