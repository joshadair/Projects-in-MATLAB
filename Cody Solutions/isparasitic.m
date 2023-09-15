function tf=isparasitic(x,n)
tf=0;
test2=num2str(x)-'0';
xn=num2str(x*n)-'0';
xn=[xn(2:end),xn(1)];

try xn==test2;
    if xn==test2
        tf=1;
    end
catch
    return
end

end