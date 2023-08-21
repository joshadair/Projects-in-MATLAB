function romStr = dec2rom_pro(n)
romStr='';
vector=num2str(n,'%04d')-'0';
tho=vector(1);
hun=vector(2);
ten=vector(3);
one=vector(4);

switch tho
    case 0
        romStr=strcat(romStr,'');
    case num2cell(1:3)
        for count=1:tho            
            romStr=strcat(romStr,'M');
        end
end

switch hun
    case 0
        romStr=strcat(romStr,'');
    case num2cell(1:3)
        for count=1:hun            
            romStr=strcat(romStr,'C');
        end
    case 4
        romStr=strcat(romStr,'CD');
    case 5
        romStr=strcat(romStr,'D');
    case num2cell(6:8)
        romStr=strcat(romStr,'D');
        for count=1:hun-5
            romStr=strcat(romStr,'C');
        end
    case 9
        romStr=strcat(romStr,'CM');
end

switch ten
    case 0
        romStr=strcat(romStr,'');
    case num2cell(1:3)
        for count=1:ten            
            romStr=strcat(romStr,'X');
        end
    case 4
        romStr=strcat(romStr,'XL');
    case 5
        romStr=strcat(romStr,'L');
    case num2cell(6:8)
        romStr=strcat(romStr,'L');
        for count=1:ten-5
            romStr=strcat(romStr,'X');
        end
    case 9
        romStr=strcat(romStr,'XC');
end

switch one
    case 0
        romStr=strcat(romStr,'');
    case num2cell(1:3)
        for count=1:one            
            romStr=strcat(romStr,'I');
        end
    case 4
        romStr=strcat(romStr,'IV');
    case 5
        romStr=strcat(romStr,'V');
    case num2cell(6:8)
        romStr=strcat(romStr,'V');
        for count=1:one-5
            romStr=strcat(romStr,'I');
        end
    case 9
        romStr=strcat(romStr,'IX');
end

end
