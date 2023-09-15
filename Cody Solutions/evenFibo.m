function y = evenFibo(d)
format long
y=0;
seq={'1' '1'};
for ind=3:d
    temp1=seq{ind-2}-'0';
    l1=length(temp1);
    temp2=seq{ind-1}-'0';
    l2=length(temp2);
    if l1<l2
        temp1=padarray(temp1,[0 l2-l1],'pre');
    end
    temp=temp1+temp2;
    seq{end+1}=num2str(polyval(temp,10));
end

for ind=1:d
    if seq{ind}(end)=='0'||seq{ind}(end)=='2'||seq{ind}(end)=='4'||seq{ind}(end)=='6'||seq{ind}(end)=='8'
        y=y+1;
    end
end
end 