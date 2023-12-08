function [gears]=aoc23_3_2(in)

%{
for i1=1:numel(in)
    temp=in{i1};
    in{i1}="."+temp+".";
end
%}


gears=[];
extras=[];
nums=['1','2','3','4','5','6','7','8','9','0'];
syms='*';
activeNum=[];

for i1=1:numel(in)
    line=char(in{i1});

    for i2=1:numel(line)

        if ismember(line(i2),nums)==1
            activeNum=[activeNum str2double(line(i2))];
        elseif isempty(activeNum)==0
            if i1==1
                prevLine='';
                nextLine=char(in{i1+1});
                nextLine=nextLine(i2-numel(activeNum)-1:i2);
                sameLine=[line(i2-numel(activeNum)-1) line(i2)];
            elseif i1==numel(in)
                prevLine=char(in{i1-1});
                prevLine=prevLine(i2-numel(activeNum)-1:i2);
                sameLine=[line(i2-numel(activeNum)-1) line(i2)];
                nextLine='';
            else
                prevLine=char(in{i1-1});
                prevLine=prevLine(i2-numel(activeNum)-1:i2);
                nextLine=char(in{i1+1});
                nextLine=nextLine(i2-numel(activeNum)-1:i2);
                sameLine=line(i2-numel(activeNum)-1:i2);              
            end

            nHood=[prevLine sameLine nextLine];

            if isempty(intersect(nHood,syms))==0
                   

                    if ismember(syms,prevLine)==1
                        index=find(prevLine==syms);
                        starLocs=[i1-1 i2-numel(prevLine)+index];
                    elseif ismember(syms,nextLine)==1
                        index=find(nextLine==syms);
                        starLocs=[i1+1 i2-numel(nextLine)+index];
                    elseif ismember(syms,sameLine)==1
                        index=find(sameLine==syms);
                        starLocs=[i1 i2-numel(sameLine)+index];
                    end

                     gears=[gears;[polyval(activeNum,10) starLocs]];
                else
                    extras=[extras;polyval(activeNum,10)];
                end



            activeNum=[];
        end
    end
end

end




