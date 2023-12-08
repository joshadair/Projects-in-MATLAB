function [parts,extras]=aoc23_3_1(in)

%{
for i1=1:numel(in)
    temp=in{i1};
    in{i1}="."+temp+".";
end
%}


parts=[];
extras=[];
nums=['1','2','3','4','5','6','7','8','9','0'];
syms=['!','@','#','$','%','&','*','-','+','=','/'];
activeNum=[];
nhood=[];

for i1=1:numel(in)
    line=char(in{i1});

    for i2=1:numel(line)

        if ismember(line(i2),nums)==1
            activeNum=[activeNum str2double(line(i2))];
        elseif isempty(activeNum)==0
            if i1==1
                postLine=char(in{i1+1});
                nhood=[line(i2-numel(activeNum)-1) line(i2) postLine(i2-numel(activeNum)-1:i2)];
            elseif i1==numel(in)
                prevLine=char(in{i1-1});
                nhood=[line(i2-numel(activeNum)-1) line(i2) prevLine(i2-numel(activeNum)-1:i2)];
            else
                prevLine=char(in{i1-1});
                postLine=char(in{i1+1});
                nhood=[line(i2-numel(activeNum)-1) line(i2) prevLine(i2-numel(activeNum)-1:i2) postLine(i2-numel(activeNum)-1:i2)];
            end

            if isempty(intersect(nhood,syms))==0
                parts=[parts;polyval(activeNum,10)];
            else
                extras=[extras;polyval(activeNum,10)];
            end
            activeNum=[];
        end
    end
end




