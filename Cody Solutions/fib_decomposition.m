function f = fib_decomposition(n)
f=[];
s=[1 1];

while max(s)<=n
    s(end+1)=s(end)+s(end-1);
end

t=n;

while sum(f)~=n
    if isempty(f)==true
       f(end+1)=s(find(s<t,1,'last')); 
    else
       f(end+1)=s(find(s<=t,1,'last')); 
    end
    t=t-f(end);
end

f=sort(f);

end