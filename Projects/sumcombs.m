function out=sumcombs(total)
out=[];

for i1=total:-1:0
    i2=total-i1;
    for i2=i2:-1:0
        i3=total-(i1+i2);
        for i3=i3:-1:0
            i4=total-(i1+i2+i3);
            out=[out;i1 i2 i3 i4];
        end
    end
end

end
