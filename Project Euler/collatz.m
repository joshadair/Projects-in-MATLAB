function out=collatz(n)
out=zeros(n,1);

for i1=1:n
    steps=0;
    a=i1;
    while a~=1
        if a<=n && out(a)~=0
            steps=steps+out(a);
            out(i1)=steps;
            break
        end


        if mod(a,2)==0
            a=a/2;
        else
            a=3*a+1;
        end
        steps=steps+1;
    end
    out(i1)=steps;
end

end