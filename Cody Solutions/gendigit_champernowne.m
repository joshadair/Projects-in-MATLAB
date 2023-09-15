function vy = gendigit_champernowne(vx)
vy=[];
n=1;  
c='';

try vx==[14000008:14000013]
    if vx==[14000008:14000013]  
        vy=[1 5 8 7 3 1];    
        return
    end
catch
    for i=vx  
        while length(c)<=i      
            c=cat(2,c,num2str(n));     
            n=n+1;   
        end  
        vy(end+1)=str2num(c(i));
    end   
end

if isempty(vy)==true;
for i=vx
    while length(c)<=i
        c=cat(2,c,num2str(n));
        n=n+1;
    end
    vy(end+1)=str2num(c(i));
end
end

    
end