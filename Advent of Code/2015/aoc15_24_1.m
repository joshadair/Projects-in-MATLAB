function out=aoc15_24_1(in)
out={};

for i1=1:length(in)
    temp=in;
    g1=[temp(i1)];
    g2=[];
    g3=[];
    temp=[temp(1:i1-1);temp(i1+1:end)];

    if sum(g1)>520
        break;
    end

    while sum(g1)<=520
        if sum(g1)+temp(1)<520
            g1=[g1;temp(1)];
            temp(1)=[];
        elseif sum(g1)+temp(1)==520
            g1=[g1;temp(1)];
            out{end+1}{1}=g1;
            temp(1)=[];

            for i2=1:length(temp)
                g2=[g2;temp(1)];
                if sum(g2)<520
                    temp(1)=[];
                    continue;
                else
                    temp(1)=[];
                    g3=temp;
                    out{end}{2}=g2;
                    out{end}{3}=g3;
                end
            end
        else
            break;
        end
    end
end
end