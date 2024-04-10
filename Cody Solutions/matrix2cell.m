function output = matrix2cell(input)
output={};
[row,col]=size(input);

for r=1:row
    for c=1:col
    output{r,c}=char(string(input(r,c)));
    end
end


end