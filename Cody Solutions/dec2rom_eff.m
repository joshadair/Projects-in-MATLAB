function romStr = dec2rom_eff(n)
romStr='';
rom_letters='MDCLXVI';
rom_values=[1000,500,100,50,10,5,1];
%rom_caps=[3,1,3,1,3,1,3];
rom_counts=zeros(1,length(rom_values));

for a=1:length(rom_values)
    if n/rom_values(a)>0
        rom_counts(a)=floor(n/rom_values(a));
        n=n-rom_values(a)*rom_counts(a);
        
        for count=1:rom_counts(a)
            romStr(end+1)=rom_letters(a);
        end       
    else
        continue
    end
end

end
        