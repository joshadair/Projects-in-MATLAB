function out=aoc16_2_b()
in=fileread('day2.txt');
in=strsplit(in);
[r,c]=size(in);
out=[];

keypad=['0' '0' '0' '0' '0' '0' '0'
        '0' '0' '0' '1' '0' '0' '0';
        '0' '0' '2' '3' '4' '0' '0';
        '0' '5' '6' '7' '8' '9' '0';
        '0' '0' 'A' 'B' 'C' '0' '0';
        '0' '0' '0' 'D' '0' '0' '0';
        '0' '0' '0' '0' '0' '0' '0'];
start=[4,2];

for i1=1:1:c
    code=in{i1};
    
    for i2=1:1:length(code)
        dir=code(i2);
        new=start;
        if dir=='U'
            new(1)=start(1)-1;
        elseif dir=='L'
            new(2)=start(2)-1;
        elseif dir=='D'
            new(1)=start(1)+1;
        elseif dir=='R'
            new(2)=start(2)+1;  
        end
        
        if keypad(new(1),new(2))=='0'
            continue
        else
            start=new;
        end     
    end
    pad_number=keypad(start(1),start(2));
    out=[out,pad_number];  
end

end