function tf=be_happy(n,b)
test=dec2base(n,b);
history={test};
while strcmp(test,'1')==0
    test=num2str(test)-'0';
    test=sum(test.*test);
    test=dec2base(test,b);
    if ismember(test,history)
        tf=0;
        return
    end
    history{end+1}=test;
end
tf=1;
end