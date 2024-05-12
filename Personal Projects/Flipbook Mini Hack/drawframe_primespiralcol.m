function s=drawframe_primespiralcol(f)
sf=1;
numcol=10;
s=spiral(sf*f);
for r=1:sf*f
    for c=1:sf*f
        active=s(r,c);
        if isprime(active)==0
            s(r,c)=0;
        else
            s(r,c)=mod(active,numcol);
            %s(r,c)=randi(numcol);
        end
    end
end
%cmp=colormap(turbo((sf*f)^2));
cmp=colormap(turbo(numcol));
%white=[1 1 1];
%cmp=[white;cmp];
s=uint16(s);
s=ind2rgb(s,cmp);
%s=imresize(s,[300 300],'box');
%imshow(s)
end