function [a,b]=aoc15_23_1(in)
a=1;
b=0;
i1=1;

while i1<=length(in)
    active=char(in(i1));
    if contains(active,"inc")==1 && active(end)=='a'
        a=a+1;
    elseif contains(active,"inc")==1 && active(end)=='b'
        b=b+1;
    elseif contains(active,"tpl")==1 && active(end)=='a'
        a=3*a;
    elseif contains(active,"tpl")==1 && active(end)=='b'
        b=3*b;
    elseif contains(active,"jio")==1 && active(5)=='a' && a==1
        if active(8)=='+'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1+str2num(active(end-1:end));
                continue;
            else
                i1=i1+str2num(active(end));
                continue;
            end
        elseif active(8)=='-'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1-active(end-1:end);
                continue;
            else
                i1=i1-active(end);
                continue;
            end
        end
    elseif contains(active,"jio")==1 && active(5)=='a' && a~=1
        i1=i1+1;
        continue;
    elseif contains(active,"jio")==1 && active(5)=='b' && b==1
        if active(8)=='+'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1+str2num(active(end-1:end));
                continue;
            else
                i1=i1+str2num(active(end));
                continue;
            end
        elseif active(8)=='-'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1-str2num(active(end-1:end));
                continue;
            else
                i1=i1-str2num(active(end));
                continue;
            end
        end
    elseif contains(active,"jio")==1 && active(5)=='b' && b~=1
        i1=i1+1;
        continue;
    elseif contains(active,"jie")==1 && active(5)=='a' && mod(a,2)==0
        i1=i1+str2num(active(end));
        continue;
    elseif contains(active,"jie")==1 && active(5)=='a' && mod(a,2)==1
        i1=i1+1;
        continue;
    elseif contains(active,"jie")==1 && active(5)=='b' && mod(a,2)==0

    elseif contains(active,"jie")==1 && active(5)=='b' && mod(a,2)==1
        i1=i1+1;
        continue;
    elseif contains(active,"jmp")
        if active(5)=='+'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1+str2num(active(end-1:end));
                continue;
            else
                i1=i1+str2num(active(end));
                continue;
            end
        elseif active(5)=='-'
            if ismember(active(end-1),['1','2','3','4','5','6','7','8','9'])==1
                i1=i1-str2num(active(end-1:end));
                continue;
            else
                i1=i1-str2num(active(end));
                continue;
            end
        end
    elseif contains(active,"hlf")==1
        a=0.5*a;
    end

    if i1>length(in)
        return;
    end
    i1=i1+1;
end
