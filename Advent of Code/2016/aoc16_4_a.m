function out=aoc16_4_a(day4)
    sectorids=[];
for i2=1:1:length(day4)
    line=day4{i2};
    firstbrack=find(line=='[');
    lastdash=find(line=='-',1,'last');
    name=line(1:lastdash-1);
    name=name(name~='-');
    checksum=line(find(line=='[')+1:end-1);

    
    for i1=1:length(checksum)
        if mode(name)==checksum(1)
            name(name==checksum(1))=[];
            if length(checksum)==1
                id=line(lastdash+1:firstbrack-1);
                sectorids=[sectorids;str2num(id)];
                
            else
                checksum=checksum(2:end);
            end
        else
            break
        end
    end
end

out=sum(sectorids);


end