function m = aoc15_3_1(input)
m=[0 0 0;0 1 0;0 0 0];
r=2;
c=2;
row=3;
col=3;

for idx=1:length(input)

    if input(idx)=='>'
        c=c+1;
        if c>col
            m=padarray(m,[0 1],0,'post');
            col=col+1;
        end

    elseif input(idx)=='<'
        c=c-1;
        if c<1
            m=padarray(m,[0 1],0,'pre');
            c=1;
            col=col+1;
        end
        
    elseif input(idx)=='^'
        r=r-1;
        if r<1
            m=padarray(m,[1 0],0,'pre');
            r=1;
            row=row+1;
        end
            
    elseif input(idx)=='v'
        r=r+1;
        if r>row
            m=padarray(m,[1 0],0,'post');
            row=row+1;
        end
    end

    m(r,c)=m(r,c)+1;
end

end


        
