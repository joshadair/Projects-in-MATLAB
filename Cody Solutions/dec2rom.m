function romStr = dec2rom(n)
romStr='';
rom_letters='MDCLXVI';
rom_counts=[];  
for m=0:n/1000     
    for d=0:(n-1000*m)  
        for c=0:(n-1000*m-500*d)   
            for l=0:(n-1000*m-500*d-100*c)     
                for x=0:(n-1000*m-500*d-100*c-50*l)  
                    for v=0:(n-1000*m-500*d-100*c-50*l-10*x)                 
                        for i=0:(n-1000*m-500*d-100*c-50*l-10*x-5*v)                       
                            vector=[m d c l x v i];                           
                            if vector*[1000;500;100;50;10;5;1]==n                           
                                rom_counts=vector;                            
                            end                         
                        end                    
                    end                 
                end            
            end         
        end     
    end 
end
for a=1:length(rom_counts)
    if rom_counts(a)==0
        continue
    else
        for count=1:rom_counts(a)
            romStr(end+1)=rom_letters(a);
        end
    end
end
    
end