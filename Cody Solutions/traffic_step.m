function a_out = traffic_step(a_in)
s=size(a_in);
a_out=zeros(s);

red=a_in==1;
red=circshift(red,1,2);
for i1=numel(red):-1:1
    a=red(i1);
    if a==1 && a_in(i1)==2
        [row,col]=ind2sub(s,i1);
        if col==1
            col=s(2)+1;
        end
        a_out(row,col-1)=1;
    elseif a==1 && a_out(i1)==1
        [row,col]=ind2sub(s,i1);
        if col==1
            col=s(2)+1;
        end
        a_out(row,col-1)=1;
    elseif a==1
        a_out(i1)=1;
    end
end

blue=a_in==2;
blue=circshift(blue,1,1);
for i1=1:numel(blue)
    if blue(i1)==1 && a_out(i1)~=1
        a_out(i1)=2;
    elseif blue(i1)==1 && a_out(i1)==1
        [row,col]=ind2sub(s,i1);
        if row==1
            row=s(1)+1;
        end
        a_out(row-1,col)=2;
    end
end

end