function count=aoc16_3_a()
fid = fopen('day3.txt','rt');
C = textscan(fid, '%f%f%f');
fclose(fid);
m=cell2mat(C);
count=0;

for i1=1:1:length(m)
    test=sort(m(i1,:));
    if test(1)+test(2)>test(3)
        count=count+1;
    end
end
    
end