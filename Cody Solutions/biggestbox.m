function [r1,r2,c1,c2] = biggestbox(input)
[row, col] = size(input);
n_maxbox = 1:min(row,col);
n_big = 0;

for r=1:row
    for c=1:col
        
        for n=n_maxbox(n_maxbox<=min(row-r+1,col-c+1))
            activematrix=input(r:r+n-1,c:c+n-1);
            
            if sum(any(activematrix)) > 0
                continue  
            elseif n>n_big
                n_big = n;
                r1 = r;
                r2 = r+n-1;
                c1 = c;
                c2 = c+n-1;
            end
        end
    end
end

end


            