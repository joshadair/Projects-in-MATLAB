function o=drawframe_fastsieve(f)
sf=50;
m=(sf*f)^2;
o=zeros(sf*f,sf*f);

o(1)=1;
a=2;

while a<m
    if o(a)==1
        a=a+1;
        continue;
    end
    o(a+a:a:m)=1;
    a=a+1;
end
o=o';
imshow(o);

end
