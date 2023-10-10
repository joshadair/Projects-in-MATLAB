function output = aoc15_6_1(input)
output=zeros(1000,1000);

for idx=1:length(input)
    [action,start_r,start_c,stop_r,stop_c]=instructs(input{idx});

    if strcmp(action,'on')==1
        for r=start_r+1:stop_r+1
            for c=start_c+1:stop_c+1
                output(r,c)=1;
            end
        end

    elseif strcmp(action,'off')==1
        for r=start_r+1:stop_r+1
            for c=start_c+1:stop_c+1
                output(r,c)=0;
            end
        end

    elseif strcmp(action,'toggle')==1
        for r=start_r+1:stop_r+1
            for c=start_c+1:stop_c+1
                output(r,c)=~output(r,c);
            end
        end

    end
end

function [action,start_r,start_c,stop_r,stop_c] = instructs(text)
        temp=split(text);
        if numel(temp)==4
            action='toggle';
            start=split(temp{2},',');
            start_r=str2num(start{1});
            start_c=str2num(start{2});
            stop=split(temp{4},',');
            stop_r=str2num(stop{1});
            stop_c=str2num(stop{2});
        else
            action=temp{2};
            start=split(temp{3},',');
            start_r=str2num(start{1});
            start_c=str2num(start{2});
            stop=split(temp{5},',');
            stop_r=str2num(stop{1});
            stop_c=str2num(stop{2});
        end
    end


end



