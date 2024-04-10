function out=PE11(in,k)
[row,col]=size(in);
vert=zeros(row,col);
hori=vert;
diagNeg=vert;
diagPos=vert;

for r=1:row-(k-1)
    for c=1:col
        vert(r,c)=prod(in(r:r+(k-1),c));
    end
end

for r=1:row
    for c=1:col-(k-1)
        hori(r,c)=prod(in(r,c:c+(k-1)));
    end
end

for r=1:row-(k-1)
    for c=1:col
        vert(r,c)=prod(in(r:r+(k-1),c));
    end
end

for r=1:row-(k-1)
    for c=1:col-(k-1)
        temp=1;
        for n=1:k
            temp=temp*in(r+(n-1),c+(n-1));
        end
        diagNeg(r,c)=temp;
    end
end

for r=row:-1:k
    for c=1:col-(k-1)
        temp=1;
        for n=1:k
            temp=temp*in(r-(n-1),c+(n-1));
        end
        diagPos(r,c)=temp;
    end
end

out=max([max(max(vert)) max(max(hori)) max(max(diagNeg)) max(max(diagPos))]);

end