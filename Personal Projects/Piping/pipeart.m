function frames=pipeart(n)
frames=[];
out=zeros(n);
frames=cat(3,frames,out);
start=randi(n^2);
out(start)=1;
frames=cat(3,frames,out);
[row,col]=ind2sub(n,start);
initR=row;
initC=col;
prev=0;
counter=2;

index=out;
trigger=0;

while ~all(index,'all') && trigger==0
    next=[1,2,3,4];
    if row==1 && col==1
        next=[2,3];
    elseif row==1 && col==n
        next=[3,4];
    elseif row==n && col==1
        next=[1,2];
    elseif row==n && col==n
        next=[1,4];
    elseif row==1
        next=[2,3,4];
    elseif row==n 
        next=[1,2,4];
    elseif col==1
        next=[1,2,3];
    elseif col==n
        next=[1,3,4];
    end
    next=next(next~=prev);
    next=next(randi(length(next)));
    switch next
        case 1
            out=out-1;
            row=row-1;
            index(row,col)=counter;
            out(row,col)=counter;
            prev=3;
        case 2
            out=out-1;
            col=col+1;
            index(row,col)=counter;
            out(row,col)=counter;
            prev=4;
        case 3
            out=out-1;
            row=row+1;
            index(row,col)=counter;
            out(row,col)=counter;
            prev=1;
        case 4
            out=out-1;
            col=col-1;
            index(row,col)=counter;
            out(row,col)=counter;
            prev=2;
    end

    out=double(out>0).*out;
    counter=counter+1;
    frames=cat(3,frames,out);

     if all(index,'all')
        if row==initR && col==initC
            trigger=1;
        end
    end


end

%cell2vid(frames,'pipeart.mp4',60);

end




