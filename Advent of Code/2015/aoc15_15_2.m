function out=aoc15_15_2(in,cookie_combs)
%cookie_combs=sumcombs(100);
scores=zeros(length(cookie_combs),5);

for i1=1:length(cookie_combs)
    scores(i1,:)=cookie_combs(i1,:)*in;
end

scores(scores<0)=0;
cals=scores(:,5);
scores_500=scores(cals==500,:);

totals_500=[];
for i1=1:length(scores_500)
    totals_500=[totals_500;prod(scores_500(i1,1:4))];
end

out=max(totals_500);
end