function out=aoc16_5_b(in)
out=NaN(1,8);
count=0;
while any(isnan(out))==true
    hashing=GetMD5([in,num2str(count)]);
    if strcmp(hashing(1:5),'00000')
        pos=hashing(6)-'0';
        if pos<=7 && isnan(out(pos+1))==true
            out(pos+1)=hashing(7);
            return
        else
            continue
        end
    end
    count=count+1;
end


end

