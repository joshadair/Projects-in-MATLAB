function output = normalizesandsize(frames)
output = frames;
[max_row,max_col] = size(output{end});
for i=1:length(output);

    [row,col] = size(output{i});
    
    while row<max_row
        switch mod(row,2)
            case 0   
                output{i} = padarray(output{i},[1 0],'pre');
            case 1
                output{i} = padarray(output{i},[1 0],'post');
        end
        [row,col] = size(output{i});
    end
    
    while col<max_col
        switch mod(col,2)
            case 0   
                output{i} = padarray(output{i},[0 1],'pre');
            case 1
                output{i} = padarray(output{i},[0 1],'post');
        end
        [~,col] = size(output{i});
    end
end
output = output;
end

        
    