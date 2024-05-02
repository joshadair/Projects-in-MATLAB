function output = collage(input_object)

if isa(input_object,'numeric') == 1
    input_temp = input_object;
    input_object = {};
    input_object{end+1} = input_temp;
elseif exist(input_object) == 2
    input_object = imgvid2cell(input_object); 
end

input_image = input_object{1};
input_image = im2double(input_image);
[rows,cols,colors] = size(input_image);

div_rows = divisors(rows);            
div_cols= divisors(cols);       
div_shared = intersect(div_rows,div_cols);    
div_shared_text = regexprep(num2str(div_shared),' +',' ');    
prompt = cat(2,'Grain size options: ',div_shared_text);        
prompt = [prompt char(10) 'Enter value from above:'];    
stripwidth_pixels = input(prompt,'s'); 
stripwidth_pixels = str2double(stripwidth_pixels);

%stripwidth_pixels = rows/strip_factor;
r_strips = rows/stripwidth_pixels;
c_strips = cols/stripwidth_pixels;

output = zeros(rows,cols,colors);
%split1 = zeros(rows/2,cols,colors);
%split2 = split1;
split1 = [];
split2 = [];

for r1=1:2:r_strips
    activestrip = input_image(1+stripwidth_pixels*(r1-1):r1*stripwidth_pixels,:,:);
    split1 = cat(1, split1, activestrip);
end

for r2=2:2:r_strips
    activestrip = input_image(1+stripwidth_pixels*(r2-1):r2*stripwidth_pixels,:,:);
    split2 = cat(1, split2, activestrip);
end

round1_img = cat(1,split1,split2);
split3 = [];
split4 = [];

for c1=1:2:c_strips     
    activestrip = round1_img(:,1+stripwidth_pixels*(c1-1):c1*stripwidth_pixels,:);
    split3 = cat(2, split3, activestrip);
end

for c2=2:2:c_strips        
    activestrip = round1_img(:,1+stripwidth_pixels*(c2-1):c2*stripwidth_pixels,:);
    split4 = cat(2, split4, activestrip);
end

output = cat(2,split3,split4);

    

    
    

