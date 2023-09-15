function y = euler004_2(x)
y=0;
trigger=0;
for i=x:-1:1
    if (trigger~=0) && (i<trigger)
        return
    end
    
    for j=i:-1:1         
        if strcmp(num2str(i*j),flip(num2str(i*j)))==1            
            if i*j>y                  
                y=i*j;
                trigger=j;
            end          
        end   
    end   
end    
end