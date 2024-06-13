function o=rndC(n,m)
%n=number of randoms to return
%m=number of digits in randoms (m=1,2,3,..), for m=1, possible randoms
%returned are: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

o=zeros(1,n);
for i1=1:n
    o(i1)=mod(tic+1/toc,10^m);
end

% Need to follow-up, alternative for returning randoms from 0 to m but
% produces clumping at divisors of m

%{
%m=max of randoms [0,m]
o=zeros(1,n);
for i1=1:n
    o(i1)=mod(tic+1/toc,m+1);
end
%}

end