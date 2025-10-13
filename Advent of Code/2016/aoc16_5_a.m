function [out1,out2]=aoc16_5_a(in)
out1=[];
out2=[];
count=23817946;
while size(out1,1)<10
    hashing=GetMD5([in,num2str(count)]);
    if strcmp(hashing(1:5),'00000')
        out1=[out1;hashing];
        out2=[out2;count];
    end
    count=count+1;
end


end

