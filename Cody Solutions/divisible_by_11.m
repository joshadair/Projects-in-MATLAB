function tf = divisible_by_11(x)
multiples_11 = [0 11 22 33 44 55 66 77 88 99];
temp = 0;
test=num2str(x);

while length(test) > 2
    test = test-'0';

    for n=1:length(test)           
        temp = temp + test(n)*((-1)^(n+1));
    end
   
    test = num2str(temp);   
end

test = str2num(test);

tf = ismember(test,multiples_11);


        