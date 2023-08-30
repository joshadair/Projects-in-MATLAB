function output = my_divisors(n)
output=[];
for x=1:n
    if mod(n,x)==0
        output(end+1)=x;
    end
end
end
