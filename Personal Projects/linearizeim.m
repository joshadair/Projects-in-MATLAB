function output = linearizeim(input)
sizearray = size(input);
row = sizearray(1);
col = sizearray(2);
output = zeros(row,col,3);

min_input = min(min(input));
max_input = max(max(input));

for r=1:row            
    for c=1:col            
        output(r,c,:) = (input(r,c)-min_input)*(255)/(max_input-min_input);        
    end    
end

output = uint8(output);

end


    