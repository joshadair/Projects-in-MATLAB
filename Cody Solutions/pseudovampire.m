function tf=pseudovampire(x)
tf=0;
divs=my_divisors(x);
 
function output = my_divisors(n)
output=[];
for x=1:n
    if mod(n,x)==0
        output(end+1)=x;
    end
end
end

digits=num2str(x)-'0';
for i=2:ceil(length(divs)/2)
    d1=num2str(divs(i))-'0';
    d2=num2str(divs(end-i+1))-'0';       
 
    if (length(d1)+length(d2))==length(digits)
        if sort([d1 d2])==sort(digits)
            tf=1;
            %return
        end
    end    
end

all_perms=perms(num2str(x))
[row,col]=size(all_perms);
for i=1:row
    
end

    


end