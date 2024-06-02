function [frames,alphaFrames]=pipeimgpix(img,n)
img=im2double(img);
[rowS,colS,~]=size(img);

divRows=divisors(rowS);
divCols=divisors(colS);
divShare=intersect(divRows,divCols);
divShareText=regexprep(num2str(divShare),' +',' ');
prompt=cat(2,'Grain size options: ',divShareText);
prompt=[prompt newline 'Enter value(s) from above:'];
newPixGrain=input(prompt,'s');
newPixGrain=str2double(newPixGrain);
index=zeros(rowS/newPixGrain,colS/newPixGrain);
[rowI,colI,~]=size(index);

frames=[];
%frames=cat(4,frames,out);
alphaFrames=[];
%alphaFrames=zeros(rowS,colS);

start=randi(rowI*colI);
[row,col]=ind2sub([rowI colI],start);
initR=row;
initC=col;
index(row,col)=1;
shading=index*n;
tempshading=imresize(shading,[rowS colS],'box');
alphaFrames=cat(3,alphaFrames,tempshading);

out=zeros(rowS,colS,3);
out((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:)=img((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:);
frames=cat(4,frames,out);
prev=0;
counter=2;
trigger=0;

while ~all(index,'all') && trigger==0
    next=[1,2,3,4];
    if row==1 && col==1
        next=[2,3];
    elseif row==1 && col==colI
        next=[3,4];
    elseif row==rowI && col==1
        next=[1,2];
    elseif row==rowI && col==colI
        next=[1,4];
    elseif row==1
        next=[2,3,4];
    elseif row==rowI
        next=[1,2,4];
    elseif col==1
        next=[1,2,3];
    elseif col==colI
        next=[1,3,4];
    end
    next=next(next~=prev);
    next=next(randi(length(next)));

    switch next
        case 1
            shading=shading-1;
            row=row-1;
            index(row,col)=counter;
            shading(row,col)=n;
            out((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:)=img((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:);
            prev=3;
        case 2
            shading=shading-1;
            col=col+1;
            index(row,col)=counter;
            shading(row,col)=n;
            out((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:)=img((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:);
            prev=4;
        case 3
            shading=shading-1;
            row=row+1;
            index(row,col)=counter;
            shading(row,col)=n;
            out((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:)=img((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:);
            prev=1;
        case 4
            shading=shading-1;
            col=col-1;
            index(row,col)=counter;
            shading(row,col)=n;
            out((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:)=img((row-1)*newPixGrain+1:row*newPixGrain,(col-1)*newPixGrain+1:col*newPixGrain,:);
            prev=2;
    end
    shading=double(shading>0).*shading;
    tempshading=imresize(shading,[rowS colS],'box');
    counter=counter+1;
    frames=cat(4,frames,out);
    alphaFrames=cat(3,alphaFrames,tempshading);

    if all(index,'all')
        if row==initR && col==initC
            trigger=1;
        end
    end


end

v=VideoWriter('new.avi');
fRate=size(frames,4)/10;
v.FrameRate=fRate;
open(v)
writeVideo(v,frames);
close(v)
end




