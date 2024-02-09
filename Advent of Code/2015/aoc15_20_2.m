function out=aoc15_20_2(in)
out=zeros(1,in*100);
for i1=1:in
    index=i1:i1:in*100;
    index=index(1:50)';
    out(index)=out(index)+i1*11;
end


end


%{
for i1=1:in
    temp=[];
    for i2=1:50
        temp=[temp;i1*i2];
    end
    out(temp)=out(temp)+i1*11;
end
%}