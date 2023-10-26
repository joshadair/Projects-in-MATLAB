function out = aoc15_11_1(in)
out=in;
t1=0;
t2=0;
t3=0;


while t1==0 | t2==0 | t3==0
    t1=0;
    t2=0;
    t3=0;
    out=out+[0 0 0 0 0 0 0 1];

    while sum(out>=123)>0
        i123=find(out>=123,1,'last');
        out(i123)=97;
        out(i123-1)=out(i123-1)+1;
    end

    for i1=1:length(out)-2
        if out(i1)==out(i1+1)-1 && out(i1+1)==out(i1+2)-1
            t1=1;
        end
    end

    if t1==0
        continue;
    end
    
    if sum(ismember([105,108,111],out))==0
        t2=1;
    else
        continue;
    end

    pairs=0;
    for i3=1:length(out)-1
        if i3==1
            if out(i3)==out(i3+1)
                pairs=pairs+1;
            end
        else
            if out(i3)==out(i3+1) && out(i3-1)~=out(i3)
                pairs=pairs+1;
            end
        end
    end

    if pairs==2
        t3=1;
    else
        continue;
    end

end

end




