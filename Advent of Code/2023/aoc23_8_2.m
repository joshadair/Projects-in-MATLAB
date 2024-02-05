function [o,steps,zIndexes]=aoc23_8_2(in1,in2,in3,script)
%o=0
start={'DVA','MPA','TDA','AAA','FJA','XPA'};

%o=5000000 {'KQJ','VHH','CBK','KTX','DTT','TQP'}
%start={'KQJ','VHH','CBK','KTX','DTT','TQP'};
stop={'DGZ','MVZ','CJZ','MSZ','ZZZ','QFZ'};
stop=sort(stop);
zIndexes=zeros(6,1);
current=start;
i1=1;
o=0;
last='A';
steps={};

while (string(unique(last))=="Z")==0 && o<100000
    temp={};
    d=script(i1);

    if d=='L'
        for active=current
            temp{end+1}=in2{strcmp(in1,active)};
        end
    elseif d=='R'
        for active=current
            temp{end+1}=in3{strcmp(in1,active)};
        end
    end

    last='';
    for i2=1:length(temp)
        last(end+1)=temp{i2}(end);
    end


  




    current=temp;
    %steps{end+1,1}=temp;
    %steps{end,2}=last;
    if i1==293
        i1=1;
    else
        i1=i1+1;
    end
    o=o+1;

      if contains(last,'Z')==1
        if zIndexes(last=='Z')==0
            zIndexes(last=='Z')=o;
        end
      end


end
steps{end+1,1}=temp;
steps{end,2}=last;
end


