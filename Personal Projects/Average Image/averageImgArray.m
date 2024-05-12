function average=averageImgArray(array)
[row,col]=size(array(:,:,1));
average=zeros(row,col);

for color=1:3
    for i1=1:length(array)
        average=average+array(:,:,i1);
    end
end

average=average/length(array);

end


