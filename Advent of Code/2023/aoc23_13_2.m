function [outr,outc]=aoc23_13_2(in)

outr=[];
outc=[];
[row,col]=size(in);

for r=1:row-1
    m1=in(1:r,:);
    m2=in(r+1:end,:);
    [rm1,~]=size(m1);
    if rm1>row/2
        [rm2,~]=size(m2);
        m1=m1(end-rm2+1:end,:);
    else
        m2=m2(1:rm1,:);
    end

    if all((m1-flip(m2,1))==0)
        outr=[outr r];
        outc=[outc 0];
    end
end

for c=1:col-1
    m1=in(:,1:c);
    m2=in(:,c+1:end);
    [~,cm1]=size(m1);
    if cm1>col/2
        [~,cm2]=size(m2);
        m1=m1(:,end-cm2+1:end);
    else
        m2=m2(:,1:cm1);
    end

    if all((m1-flip(m2,2))==0)
        outr=[outr 0];
        outc=[outc c];
    end
end


end



