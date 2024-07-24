function frames=traffic(n,nColors,spacing)
%n=matrix size
%nColors=number of colors
%spacing=interval between new cars

frames=[];
a=zeros(n);
frames=cat(3,frames,a);

for i1=1:n
    a(end,i1)=randi(nColors);
end

count=0;
while any(any(a)) && size(frames,3)<1000
    for i1=1:n
        col=a(:,i1);
        cars=(find(col>0));
        for i2=cars
            rate=col(i2);
            if i2==1
                break
            else
                try space=col(i2-rate:i2-1);
                catch
                end
            end

            if ~any(space)
                try a(i2-rate,i1)=rate;
                catch
                end
            else
                try a(i2-(length(space)-find(space~=0,1,'last')),i1)=rate;
                catch
                end
            end
            a(i2,i1)=0;
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

