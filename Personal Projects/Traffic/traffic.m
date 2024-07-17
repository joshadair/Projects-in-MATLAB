function frames=traffic(n,nColors,spacing)
frames=[];
a=zeros(n);
frames=cat(3,frames,a);

for i1=1:n
    a(end,i1)=randi(nColors);
end

count=0;
while any(any(a)) && size(frames,3)<1000
    %frames=cat(3,frames,a);

    for i1=1:n
        col=a(:,i1);
        cars=(find(col>0));
        for i2=1:numel(cars)
            col=a(:,i1);
            position=cars(i2);
            rate=col(position);
            if i2==1
                space=col(1:position-1);
            else
                try space=col(position-rate:position-1);
                catch
                    space=col(1:position-1);
                end
            end

            if ~any(space)
                try a(position-rate,i1)=rate;
                catch
                end
            else
                try a(position-(length(space)-find(space~=0,1,'last')),i1)=rate;
                catch
                end
            end
            a(position,i1)=0;
        end
    end
    frames=cat(3,frames,a);
    count=count+1;

    if mod(count,spacing)==0 
        for i1=1:n
            a(end,i1)=randi(nColors);
        end
        %frames=cat(3,frames,a);
    end

end

end

