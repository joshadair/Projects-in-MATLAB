x = '1010010101011010101001011010100101101010010100101101010011010100101';
multiples_11 = [0 11 22 33 44 55 66 77 88 99];
temp = 0;
test=x;


while length(test) > 2
    test = test-'0';

    for n=1:length(test)
            temp = temp + test(n)*((-1)^(n+1));
    end
   
    test = num2str(temp);
    
end


test = str2num(test)

ismember(test,multiples_11)


        