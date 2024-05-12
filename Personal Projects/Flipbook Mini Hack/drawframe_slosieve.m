function drawframe_slosieve(f)
sf=10;
m=(sf*f)^2;
o=zeros(sf*f,sf*f);

o(1)=1;
a=2;

while a<m
    if o(a)==1
        a=a+1;
        continue;
    end

    for i1=a+1:m
        if mod(i1,a)==0
            o(i1)=1;
        end
    end

    a=a+1;

end

o=o';
%o=imresize(o,[600 600],'box');
imshow(o);


end
