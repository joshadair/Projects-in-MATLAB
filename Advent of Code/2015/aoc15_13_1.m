function happy_scores=aoc15_13_1(in)
p=perms(1:8);
happy_scores=[];
for i1=1:length(p)
    happy=0;
    active=p(i1,:);
    for i2=1:8;
        if i2>1 && i2 <8       
            happy=happy+in(active(i2),active(i2-1))+in(active(i2),active(i2+1));
        elseif i2==1
            happy=happy+in(active(i2),active(8))+in(active(i2),active(i2+1));
        elseif i2==8
            happy=happy+in(active(i2),active(1))+in(active(i2),active(i2-1));
        end       
    end
               happy_scores=[happy_scores;happy];
end