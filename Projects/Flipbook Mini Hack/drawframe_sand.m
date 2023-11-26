function drawframe_sand(f)
in=uint16(padarray(4*ones(100),[25 25],0,'both'));
o=in;
[rw,cl]=size(o);

%{
if n>24
    n=25-(n-24);
end
%}

for i=1:50*f
    if f==1 
        break;
    else
    for r=1:rw
        for c=1:cl
            if in(r,c)>3
                o(r-1,c)=o(r-1,c)+1;
                o(r+1,c)=o(r+1,c)+1;
                o(r,c-1)=o(r,c-1)+1;
                o(r,c+1)=o(r,c+1)+1;
                o(r,c)=o(r,c)-4;
            end
        end
    end
    end
    in=o;
end

cmp=colormap(turbo(1+max(max(o))));
o=ind2rgb(o,cmp);
o=imresize(o,[1000 1000],'box');
imshow(o)
end


