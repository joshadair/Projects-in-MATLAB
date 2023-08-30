function y = euler004(x)

for i=x^2:-1:1
    if strcmp(num2str(i),flip(num2str(i)))==1
        if isprime(i)==0   
            divs=divisors(i);          
            if divs(end)<=x
                y=i;         
                return
            end          
        end
    end
end

end