function drawframe_pspiral(f)
sf=10;
s=sf*f;
o=spiral(s);

for r=1:s
    for c=1:s
        if isprime(o(r,c))==1
            o(r,c)=0;
        end
    end
end

o=imresize(o,[600 600],'box');
imshow(o);

end

