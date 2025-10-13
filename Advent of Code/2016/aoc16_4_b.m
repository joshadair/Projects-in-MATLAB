function out=aoc16_4_b(day4)
    alphabet='a':'z';
    out={};
    
for i2=1:1:length(day4)
    line=day4{i2};
    firstbrack=find(line=='[');
    lastdash=find(line=='-',1,'last');
    id=str2num(line(lastdash+1:firstbrack-1));   
    name=line(1:lastdash-1);   
    cipher=circshift(alphabet,id,2);
    decoded=name;
    
    for i1=1:1:length(name)
        if name(i1)=='-'
            continue
        else
            decoded(i1)=alphabet(find(cipher==name(i1)));
        end
    end
    
    out{end+1}=decoded;
end
out=out';
end