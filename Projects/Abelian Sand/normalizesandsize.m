function output=normalizesandsize(frames)
output=frames;
[max_row,max_col]=size(output{end});
for i1=1:length(output)
    [row,col]=size(output{i1});
    output{i1}=padarray(output{i1},[(max_row-row)/2,(max_col-col)/2]);
end

end



