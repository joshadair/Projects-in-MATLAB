function m = aoc15_3_2(input)
m=[0 0 0;0 2 0;0 0 0];
r1=2;
c1=2;
r2=2;
c2=2;
row=3;
col=3;



for idx=1:length(input)

    if mod(idx,2)==1

        if input(idx)=='>'
            c1=c1+1;
            if c1>col
                m=padarray(m,[0 1],0,'post');
                col=col+1;
            end

        elseif input(idx)=='<'
            c1=c1-1;
            if c1<1
                m=padarray(m,[0 1],0,'pre');
                c1=1;
                c2=c2+1;
                col=col+1;
            end

        elseif input(idx)=='^'
            r1=r1-1;
            if r1<1
                m=padarray(m,[1 0],0,'pre');
                r1=1;
                r2=r2+1;
                row=row+1;
            end

        elseif input(idx)=='v'
            r1=r1+1;
            if r1>row
                m=padarray(m,[1 0],0,'post');
                row=row+1;
            end
        end

        m(r1,c1)=m(r1,c1)+1;

    elseif mod(idx,2)==0
        if input(idx)=='>'
            c2=c2+1;
            if c2>col
                m=padarray(m,[0 1],0,'post');
                col=col+1;
            end

        elseif input(idx)=='<'
            c2=c2-1;
            if c2<1
                m=padarray(m,[0 1],0,'pre');
                c2=1;
                c1=c1+1;
                col=col+1;
            end

        elseif input(idx)=='^'
            r2=r2-1;
            if r2<1
                m=padarray(m,[1 0],0,'pre');
                r2=1;
                r1=r1+1;
                row=row+1;
            end

        elseif input(idx)=='v'
            r2=r2+1;
            if r2>row
                m=padarray(m,[1 0],0,'post');
                row=row+1;
            end
        end

        m(r2,c2)=m(r2,c2)+1;
    end
end

end


        
