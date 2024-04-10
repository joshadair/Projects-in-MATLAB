function out=euler12(n)

triangle=sum(1:n);
d=divisors(triangle);

while length(d)<=500
    n=n+1;
    triangle=sum(1:n);
    d=mydivisors(triangle);
end

out=uint64(triangle);

    function d=mydivisors(num)
        d=[];
        for x=1:num
            if mod(num,x)==0
                d(end+1)=x;
            end
        end
    end

end


