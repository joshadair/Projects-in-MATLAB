function o=drawframe_sieve(f)
sf=6;
max=(sf*f)^2;
n=[];
for i1=1:max^(1/2):max
    n=[n;i1:i1+(sf*f-1)];
end
n=n';
[row,col]=size(n);
o=zeros(row,col);

o(1)=1;
active=2;

while active<max

for i1=active+1:max
    if mod(n(i1),active)==0
        o(i1)=1;
    end
end

active=active+1;

end

o=o';
o=imresize(o,[600 600],'box');
imshow(o);


end
