function num = aoc15_4_1(input)
num=1000000;
test='11111';
trigger=0;
while trigger==0
    test=GetMD5(char(input+num2str(num)));
    if strcmp(test(1:6),'000000')==0  
        num=num+1;
    else
        trigger=1;
    end
end

end