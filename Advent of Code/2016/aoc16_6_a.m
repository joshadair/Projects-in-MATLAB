function out=aoc16_6_a()
in=fileread('day6.txt');
in=strsplit(in);
[r,c]=size(in);
out=[];
temp=cell(8,1);

for i1=1:1:c
    for i2=1:1:8
    a=in{i1}(i2);
    temp{i2}(end+1)=a;
    end
end

for i3=1:1:8
    out(end+1)=mode(temp{i3});
end

     
end


