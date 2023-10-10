function output = aoc15_8_1_2(input)
output=input;

pat="\x"+alphanumericsPattern(2);
t3=strfind(output,pat);
if isempty(t3)==0
    t3_vals={};
    for idx1=1:length(t3)
        test=output(t3(idx1)+2:t3(idx1)+3);
        try dec=hex2dec(test);
            %%if dec>=33 && dec~=127
            t3_vals{end+1}="\x"+test;
            %%end
        catch
            t3_vals{end+1}="0";
        end
    end

    for idx2=1:length(t3_vals)
        if t3_vals{idx2}~="0"
            if isspace(char(hex2dec(t3_vals{idx2}{1}(3:4))))==0
            output=replace(output,t3_vals{idx2},char(hex2dec(t3_vals{idx2}{1}(3:4))));
            else
                continue;
            end
        end
    end
end

output=replace(output,"\\","\");
output=replace(output,'\"','"');

end










