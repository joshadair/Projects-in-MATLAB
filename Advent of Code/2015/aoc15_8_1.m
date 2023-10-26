function [lit,mem,diff] = aoc15_8_1(input);
lit=[];
mem=[];

for idx1=1:numel(input)

    % extract string from input cell, ignoring starting/ending double quotes
    active=input{idx1}(2:end-1);

    % literal numel is active+2 to account for previously removed double quotes
    lit=[lit;numel(active)+2];

    % find occurences of \\ and account for overlap by checking that
    % index of occurence is greater than 1+ previous
    t1_temp=strfind(active,"\\");
    t1=[];
    if numel(t1_temp)==1
        t1(1)=t1_temp(1);
    elseif numel(t1_temp)>1
        t1(1)=t1_temp(1);
        for idx2=2:numel(t1_temp)
            % conditional to check for overlap
            if t1_temp(idx2)~=t1_temp(idx2-1)+1;
                t1(end+1)=t1_temp(idx2);
            end
        end
    end

    % no need to check for overlap for \"
    t2=strfind(active,"\"+char(34));

    % find occurences of \x with hexadecimal value, i.e. pattern of \x##
    pat="\x"+alphanumericsPattern(2);
    t3_temp=strfind(active,pat);

    % indexes where hexadecimal values are characters; these values
    % result in a reduction of 3 characters: \x## -> #
    t3_char=[];

    % indexes where hexadecimal values are not characters (spaces, returns,
    % commands, etc.); these values result in a reduction of 4 characters:
    % \x## -> ''
    t3_blank=[];

    if numel(t3_temp)>0
        for idx3=1:numel(t3_temp)


            % testing for false positives of \\x##, note: \\\x## is not false positive
            % because first \ pairs up with second and leaves third with \x##
            if t3_temp(idx3)==2 && active(1)=="\"
                continue;
            elseif t3_temp(idx3)>2 && active(t3_temp(idx3)-1)=="\" && active(t3_temp(idx3)-2)~="\"
                continue;
            end


            % ensure that pattern match for \x## is a hexadecimal value
            try test=hex2dec(string(active(t3_temp(idx3)+2))+string(active(t3_temp(idx3)+3)));
                % test is hex converted to dec, dec<33 are ASCII non-character
                % commands, dec==127 is delete
                %if test>=33 && test ~=127
                    t3_char(end+1)=t3_temp(idx3);
                %else
                    %t3_blank(end+1)=t3_temp(idx3);
                %end
                % if pattern match for \x## is not a hexadecimal value then assume
                % /x## remains untouched in string (i.e. literal representation is
                % same as that of in-memory)
            catch
                continue;
            end
        end
    end
    % t1 and t2 result in a reduction of 1 (\\ -> \ and \" -> ") and t3 depends
    % on whether hex value relates to character (-3) or non-character (-4)
    % mem=[mem;numel(active)-numel(t1)-numel(t2)-3*numel(t3_char)-4*numel(t3_blank)];
    mem=[mem;numel(active)-numel(t1)-numel(t2)-3*numel(t3_char)-4*numel(t3_blank)];
end
diff=lit-mem;
end

