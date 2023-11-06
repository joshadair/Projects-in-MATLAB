function out=datadecode(in)
numbers=[];
text=[];
pyramid=[];
out="";

for i1=1:size(in,1)
    active=split(in(i1));
    number=str2num(active(1));
    numbers=[numbers;number];
    word=active(2);
    text=[text;word];
end

counter=1;
i1=1;
while counter<=length(numbers)
    for i2=1:i1;
        pyramid(i1,i2)=counter;
        counter=counter+1;
    end
    i1=i1+1;
end

usewords=diag(pyramid);

for i1=1:length(usewords)
    active=text(numbers==usewords(i1));
    if i1==1
        out=active+" ";
    elseif i1==length(usewords)
        out=out+active;
    else
        out=out+active+" ";
    end
end

end
