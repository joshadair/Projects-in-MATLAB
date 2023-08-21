function sOut = rsreveeTxet(sIn)
sOut=[];
vector=double(sIn);
nextspace = 0;
for i=1:length(vector);
    if ismember(vector,32)==0
        sOut = [vector(1) flip(vector(2:end-1)) vector(end)];
        break
    elseif (i==1 && nextspace==0)
        nextspace=i+find((vector(i+1:end))==32,1);
        word=vector(i:nextspace-1);       
        word_reverse=[word(1) flip(word(2:end-1)) word(end)];          
        sOut=[sOut word_reverse];
    elseif i>nextspace
        if ((vector(i)>=33 && vector(i)<=64) || (vector(i)>=91 && vector(i)<=96) || (vector(i)>=123 && vector(i)<=126))
            sOut(end+1)=vector(i);
        else
            if ismember(32,vector(i:end)) == 0
                if ((vector(end)>=33 && vector(end)<=64) || (vector(end)>=91 && vector(end)<=96) || (vector(end)>=123 && vector(end)<=126))
                    word=vector(i:end-1);
                    if length(word)>3
                        word_reverse=[word(1) flip(word(2:end-1)) word(end)];
                    else
                        word_reverse=word;
                    end               
                    sOut=[sOut 32 word_reverse vector(end)];
                    break
                else                   
                    word=vector(i:end);
                    if length(word)>3
                        word_reverse=[word(1) flip(word(2:end-1)) word(end)];
                    else
                        word_reverse=word;
                    end               
                    sOut=[sOut 32 word_reverse];  
                    break
                end            
            else
                nextspace=i+find((vector(i+1:end))==32,1);
                word=vector(i:nextspace-1);
                if length(word)>3
                    word_reverse=[word(1) flip(word(2:end-1)) word(end)];
                else
                    word_reverse=word;
                end
                sOut=[sOut 32 word_reverse];           
            end
        end
    elseif i<nextspace
        continue
    end 
end
sOut = char(sOut);
end

        
        