function out=aoc23_12_allcombs(n)
out={};


for i1=1:n
    combs=zeros(2^i1,i1);
for i2=2:2^i1
    active=dec2bin(i2-1,i1);
    combs(i2,:)=active-'0';
end
out{i1}=combs;

end


end

