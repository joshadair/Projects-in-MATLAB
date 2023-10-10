function [diff,lit,mem] = aoc15_8_1(input);
lit=[];
mem=[];

for idx1=1:numel(input)
    active=input{idx1}(2:end-1);
    lit(idx1)=length(active)+2;

    t1_temp=strfind(active,"\\");
    if length(t1_temp)<=1
        t1=t1_temp;
    else
        t1=t1_temp(1);
        for idx2=2:length(t1_temp)
            if t1_temp(idx2)~=t1(end)+1
                t1(end+1)=t1_temp(idx2);
            end
        end
    end


    t2=strfind(active,"\"+char(34));

    t3_temp=strfind(active,"\x");
    t3=[];

    if numel(t3_temp)>0

        for idx3=1:numel(t3_temp)

            try test=hex2dec(string(t3_temp(idx3)+2)+string(t3_temp(idx3)+3));
               %% if test>=33 && test~=127                         
                    t3(end+1)=4-length(char(test));
              %%  else
              %%      t3(end+1)=4;
               %% end
            catch
                continue;
            end

            %{
            if isstrprop(active(t3_temp(idx3)+2),'alphanum')==1 && isstrprop(active(t3_temp(idx3)+3),'alphanum')==1
                if hex2dec(string(t3_temp(idx3)+2)+string(t3_temp(idx3)+3))<=32 || hex2dec((t3_temp(idx3)+2)+(t3_temp(idx3)+3))==127
                    t3(end+1)=t3_temp(idx3);
                else
                    t4(end+1)=t3_temp(idx3);
                end         
            end
            %}

        end
    end

    mem(idx1)=length(active)-length(t1)-length(t2)-sum(t3);
end
lit=lit';
mem=mem';
diff=lit-mem;
end

