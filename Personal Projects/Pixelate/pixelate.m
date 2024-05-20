function [compressed_cell,fullsize_cell] = pixelate(input_object)

compressed_cell={};
fullsize_cell={};

if isa(input_object,'numeric') == 1
    input_temp=input_object;
    input_object={};
    input_object{end+1}=input_temp;
elseif exist(input_object)==2
    input_object=imgvid2cell(input_object); 
end

input_image=im2double(input_object{1});
[rows,cols,colors]=size(input_image);        
div_rows=divisors(rows);            
div_cols=divisors(cols);       
div_shared=intersect(div_rows,div_cols);    
div_shared_text=regexprep(num2str(div_shared),' +',' ');    
prompt=cat(2,'Grain size options: ',div_shared_text);        
prompt=[prompt char(10) 'Enter value(s) from above or use "all":'];    
new_pixelGrain=input(prompt,'s');    
    
if strcmp(new_pixelGrain,'all') == 1        
    new_pixelGrain_options=cat(2,div_shared,flip(div_shared));        
    new_pixelGrain_length=length(new_pixelGrain_options);
          
    if length(input_object)==1            
        for count=1:new_pixelGrain_length               
            input_object{end+1}=input_image;            
        end
    end   
else
   new_pixelGrain=str2double(new_pixelGrain);
   new_pixelGrain_options=new_pixelGrain;
   new_pixelGrain_length=length(new_pixelGrain_options);
end

num_cells = length(input_object);
      
for a=1:num_cells         
    input_image=im2double(input_object{a});
        
    new_pixelGrain=new_pixelGrain_options(ceil((a/num_cells)*new_pixelGrain_length));    
    
    rSteps=rows/new_pixelGrain;
    cSteps=cols/new_pixelGrain;

    compressed_image = [];    
    compressed_image(:,:,1) = zeros(rSteps,cSteps);
    compressed_image(:,:,2) = zeros(rSteps,cSteps);    
    compressed_image(:,:,3) = zeros(rSteps,cSteps);
    fullsize_image = [];
    fullsize_image(:,:,1) = zeros(rows,cols);
    fullsize_image(:,:,2) = zeros(rows,cols);
    fullsize_image(:,:,3) = zeros(rows,cols);
   
    for clr=1:colors     
        activeRGB=input_image(:,:,clr);
        for x=1:rSteps                
            for y=1:cSteps               
                floatColor=0;                 
                pixelCount=new_pixelGrain^2;               
                
                for n=1:new_pixelGrain                    
                    for m=1:new_pixelGrain                          
                        floatColor=floatColor+activeRGB(n+(x-1)*new_pixelGrain,m+(y-1)*new_pixelGrain);                    
                    end                    
                end
                                
                new_pixelColor=floatColor/pixelCount;           
                compressed_image(x,y,clr)=new_pixelColor;                

                for a=1:new_pixelGrain                    
                    for b=1:new_pixelGrain                                                                                  
                        fullsize_image((x-1)*new_pixelGrain+a,(y-1)*new_pixelGrain+b,clr)=new_pixelColor;                                                    
                    end                    
                end                
            end            
        end     
    end
    
    compressed_cell{end+1}=compressed_image;
    fullsize_cell{end+1}=fullsize_image;
    
end

end
