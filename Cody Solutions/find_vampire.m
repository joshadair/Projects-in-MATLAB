function y =find_vampire(x)
y=[];

[row,col]=size(x);
if row>1 && col>1
    x=reshape(x,1,[]);
end




for i1=x
    divisors=my_divisors(i1);
    ndiv=length(divisors);
    
    for i2=1:ndiv/2
        div1=divisors(i2);
        div2=divisors(end-i2+1);
        
        if (mod(div1,10)==1) && (mod(div2,10)==1)
            continue;
        end
        
        div1=num2str(div1)-'0';
        div2=num2str(div2)-'0';
        
        if length(div1)~=length(div2)
            continue;
        end
        
        test1=[div1, div2];
        test2=num2str(i1)-'0';
        
        try sort(test1)==sort(test2)
            if sort(test1)==sort(test2)
                 y(end+1)=i1;
            end
        catch
            continue
        end  
        
    end
end
    
end