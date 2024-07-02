function frames=traffic(n,direction)
frames=[];
a=zeros(n);

for i1=1:n
    a(end,i1)=randi(5);
end

frames(end+1)=a;

for i1=1:n
    rate=a(end,i1);
    space=a(end-rate:end,i1)
    a(end-rate,i1)=rate;
    a(end,i1)=0;

    switch a(end,i1)
        case 1
            
        case 2
    
    end

        
end




end
