function frames=pipeimg(input)
[rowS,colS,~]=size(input);
frames=[];
index=zeros(rowS,colS);
out=zeros(rowS,colS,3);
frames=cat(4,frames,out);

start=randi(rowS*colS);
[row,col]=ind2sub([rowS colS],start);
index(row,col)=1;
out(row,col,:)=input(row,col,:);
prev=0;
counter=2;

while ~all(index,'all')
    next=[1,2,3,4];
    if row==1 && col==1
        next=[2,3];
    elseif row==1 && col==colS
        next=[3,4];
    elseif row==rowS && col==1
        next=[1,2];
    elseif row==rowS && col==colS
        next=[1,4];
    elseif row==1
        next=[2,3,4];
    elseif row==rowS 
        next=[1,2,4];
    elseif col==1
        next=[1,2,3];
    elseif col==colS
        next=[1,3,4];
    end
    next=next(next~=prev);
    next=next(randi(length(next)));

    switch next
        case 1
            row=row-1;
            index(row,col)=counter;
            out(row,col,:)=input(row,col,:);
            prev=3;
        case 2
            col=col+1;
            index(row,col)=counter;
            out(row,col,:)=input(row,col,:);
            prev=4;
        case 3
            row=row+1;
            index(row,col)=counter;
            out(row,col,:)=input(row,col,:);
            prev=1;
        case 4
            col=col-1;
            index(row,col)=counter;
            out(row,col,:)=input(row,col,:);
            prev=2;
    end

    counter=counter+1;
    frames=cat(4,frames,out);
end

%cell2vid(frames,'pipeart.mp4',60);

end




