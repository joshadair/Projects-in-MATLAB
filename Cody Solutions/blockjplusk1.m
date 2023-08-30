function A = blockjplusk1(m,n,p,q)
A = zeros(m*p,n*q);
for rstep=1:m
    for cstep=1:n
        element=rstep+cstep-1;
        newblock=element*ones(p,q);
        A(1+p*(rstep-1):1+p*(rstep-1)+p-1,1+q*(cstep-1):1+q*(cstep-1)+q-1)=newblock;
    end
end
        
end