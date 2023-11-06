function [red,nored]=aoc15_12_2help(in)
red=[];
nored=[];
object="";
n=sum(ismember(in,'{'));

while n>0
    last_open=find(in=='{',1,'last');
    next_close=last_open+find(in(last_open:end)=='}',1,'first')-1;
    last_open2=find(in=='{',2,'last');
    next_close2=last_open2+find(in(last_open:end)=='}',1,'first')-1;

    if next_close2>next_close
        object=string(in(last_open2:next_close2));
    else
        object=string(in(last_open:next_close));
    end

    if contains(object,"red")==1
        red=[red;object];
    else
        nored=[nored;object];
    end

    in(last_open:next_close)='';
    n=sum(ismember(in,'{'));
end

nored=[nored;in];

end

