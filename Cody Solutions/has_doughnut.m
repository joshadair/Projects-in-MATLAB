function [tf, output] = has_doughnut(a)
[row,col] = size(a);

for c=1:col
    if a(1,c) == 0
        a(1,c) = -1;
    end
    
    if a(end,c) == 0
        a(end,c) = -1;
    end
end

for r=1:row
    if a(r,1) == 0
        a(r,1) = -1;
    end
    
    if a(r,end) == 0
        a(r,end) = -1;
    end
end




for r=2:row-1
    for c=2:col-1
        if a(r,c) == 0
            activematrix = a(r-1:r+1,c-1:c+1);
            if ismember(-1,activematrix) == true
                a(r,c) = -1;
            end
        end
    end
end
 
output = a;

if ismember(0,output) == true
    tf = true;
else
    tf = false;
end

end