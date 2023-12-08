function drawframe_primespiral(f)
sf=6;
o=ones(sf*f);
s=spiral(sf*f);
for r=1:sf*f
    for c=1:sf*f
        if isprime(s(r,c))==1
            o(r,c)=0;
        end
    end
end
o=imresize(o,[600 600],'box');
imshow(o)
end