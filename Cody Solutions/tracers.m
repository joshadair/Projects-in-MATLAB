function out=tracers(x,y)
out1=[];
out2=[];
[rowx,colx]=size(x);
i2=1;

for i1=y
    if i2>1
        out1(end)=[];
        out2(end)=[];
    end
    
    l1=linspace(x(i2,1),x(i2+1,1),i1);     
    l2=linspace(x(i2,2),x(i2+1,2),i1);       
    out1=[out1, l1];       
    out2=[out2, l2];       
    i2=i2+1;
end

out=[out1;out2]';

end