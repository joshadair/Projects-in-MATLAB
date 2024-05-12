function output_array = cell2_4Darray(input_cell)

[m,n,k] = size(input_cell{1});
output_array = zeros(m,n,k,length(input_cell));

for x=1:length(input_cell)
    output_array(:,:,:,x) = input_cell{x};
end

