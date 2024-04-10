function s2 = rot13(s1)
in='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
out='NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm';
s2="";

for i1=1:length(s1)
    a=s1(i1);
    if any(in==a)
        s2=s2+out(in==a);
    else
        s2=s2+s1(i1);
    end
end

end