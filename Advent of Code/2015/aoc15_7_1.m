function [wires,values,commands] = aoc15_7_1(input)
wires=[];
values=[];
commands={};
i=input;

for idx=1:numel(input)
    i{idx}=split(i{idx},' ');
    wires=[wires;string(i{idx}{end})];
    commands{idx}=i{idx}(1:end-2);
    values=[values;NaN];
end

for idx=1:numel(commands)
    if length(commands{idx})==1 && isempty(str2num(commands{idx}{1}))==0
        values(idx)=uint16(str2num(commands{idx}{1}));
    end
end

while sum(isnan(values))~=0
    for idx=1:numel(commands)
        if length(commands{idx})==3
            if strcmp(commands{idx}{2},'LSHIFT')==1
                if isnan(values(find(wires==commands{idx}{1})))==0
                    values(idx)=bitsll(uint16(values(find(wires==commands{idx}{1}))),str2num(commands{idx}{3}));
                end
            elseif strcmp(commands{idx}{2},'RSHIFT')==1
                if isnan(values(find(wires==commands{idx}{1})))==0
                    values(idx)=bitsrl(uint16(values(find(wires==commands{idx}{1}))),str2num(commands{idx}{3}));
                end
            elseif strcmp(commands{idx}{2},'AND')==1
                if isempty(str2num(commands{idx}{1}))==0 && isnan(values(find(wires==commands{idx}{3})))==0
                    values(idx)=bitand(uint16(str2num(commands{idx}{1})),uint16(values(find(wires==commands{idx}{3}))));
                elseif isempty(str2num(commands{idx}{1}))==1 && isnan(values(find(wires==commands{idx}{1})))==0 && isnan(values(find(wires==commands{idx}{3})))==0
                    values(idx)=bitand(uint16(values(find(wires==commands{idx}{1}))),uint16(values(find(wires==commands{idx}{3}))));
                end
            elseif strcmp(commands{idx}{2},'OR')==1
                if isnan(values(find(wires==commands{idx}{1})))==0 && isnan(values(find(wires==commands{idx}{3})))==0
                    values(idx)=bitor(uint16(values(find(wires==commands{idx}{1}))),uint16(values(find(wires==commands{idx}{3}))));
                end
            end

        elseif length(commands{idx})==2
            if isnan(values(find(wires==commands{idx}{2})))==0
                values(idx)=bitcmp(uint16(values(find(wires==commands{idx}{2}))));
            end

        elseif length(commands{idx})==1 && isempty(str2num(commands{idx}{1}))==1
            if isnan(values(find(wires==commands{idx}{1})))==0
                values(idx)=uint16(values(find(wires==commands{idx}{1})));
            end
        end
    end
end

end


