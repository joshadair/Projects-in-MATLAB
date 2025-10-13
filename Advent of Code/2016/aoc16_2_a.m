function out=aoc16_2_a()
in=fileread('day2.txt');
in=strsplit(in);
[r,c]=size(in);
out=[];

keypad=[1 2 3;4 5 6;7 8 9];
start=[2,2];

for i1=1:1:c
    code=in{i1};
    
    for i2=1:1:length(code)
        dir=code(i2);
        if dir=='U'
            start(2)=start(2)-1;
        elseif dir=='L'
            start(1)=start(1)-1;
        elseif dir=='D'
            start(2)=start(2)+1;
        elseif dir=='R'
            start(1)=start(1)+1;  
        end
        
        start(start>3)=3;
        start(start<1)=1;     
    end
    
    pad_number=keypad(start(2),start(1));
    out=[out,pad_number];
 
    
end

end