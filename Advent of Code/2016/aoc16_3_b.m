function count=aoc16_3_b()
fid = fopen('day3.txt','rt');
C = textscan(fid, '%f%f%f');
fclose(fid);
m=cell2mat(C);
count=0;
[r,c]=size(m);

for i1=1:3:r*c
    test=sort(m(i1:i1+2));
    if test(1)+test(2)>test(3)
        count=count+1;
    end
end
    
end