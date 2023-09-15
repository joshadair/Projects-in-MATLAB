function L = recurring_cycle(d)
L=zeros(1,d);
for d=1:d
    remainders=[];
    rem=mod(10,d);
    while rem~=0 && ismember(rem,remainders)==0
        remainders(end+1)=rem;
        rem=mod(rem*10,d);
    end
    if rem==0
        L(d)=0;
    else
        L(d)=length(remainders);
    end
end


end