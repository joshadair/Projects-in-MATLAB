function o=aoc23_1_2(in)
o=[];
num=[];
numbers=["one","two","three","four","five","six","seven","eight","nine"];
active=char(in);

for i2=1:numel(active)
    if ismember(active(i2),['1','2','3','4','5','6','7','8','9'])==1
        if i2==1
            num=[num str2num(active(i2))];
            break;
        else
            pre=active(1:i2-1);
        end

        if contains(pre,{'one','two','three','four','five','six','seven','eight','nine'})==1
            vals=[];
            locs=[];
            for nums=1:9
                if contains(pre,numbers(nums))==1
                    vals=[vals;nums];
                    loc=strfind(pre,numbers(nums));
                    locs=[locs;loc(1)];
                end
            end
            [~,min_loc]=min(locs);
            num=[num vals(min_loc)];
            break;
        else
            num=[num str2num(active(i2))];
            break;
        end
    end
end

for i3=numel(active):-1:1
    if ismember(active(i3),['1','2','3','4','5','6','7','8','9'])==1
        if i3==numel(active)
            num=[num str2num(active(i3))];
            break;
        else
            post=active(i3+1:end);
        end

        if contains(post,{'one','two','three','four','five','six','seven','eight','nine'})==1
            vals=[];
            locs=[];
            for nums=1:9
                if contains(post,numbers(nums))==1
                    vals=[vals;nums];
                    loc=strfind(post,numbers(nums));
                    locs=[locs;loc(end)];
                end
            end
            [~,max_loc]=max(locs);
            num=[num vals(max_loc)];
            break;
        else
            num=[num str2num(active(i3))];
            break;
        end
    end
end
o=[o;num];
end