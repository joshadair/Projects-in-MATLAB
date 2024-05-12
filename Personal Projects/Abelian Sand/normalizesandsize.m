function output=normalizesandsize(frames)
[max_row,max_col]=size(frames{end});
output=[];
for i1=1:length(frames)
    [row,col]=size(frames{i1});
    new=padarray(frames{i1},[(max_row-row)/2,(max_col-col)/2]);
    output=cat(3,output,new);
end

end



