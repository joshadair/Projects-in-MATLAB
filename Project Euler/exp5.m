function out=exp5()
out=[];

for i1=1:999999
    s=char(string(i1));
    s=s-'0';
    s=sum(s.^5);

    if s==i1
        out(end+1)=i1;
    end
end

end