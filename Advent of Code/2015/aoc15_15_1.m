function out=aoc15_15_1(in,cookie_combs)
%cookie_combs=sumcombs(100);
scores=zeros(length(cookie_combs),5);

for i1=1:length(cookie_combs)
    scores(i1,:)=cookie_combs(i1,:)*in;
end

scores(scores<0)=0;
scores=scores(:,1:4);

out=max(prod(scores,2));

end