function [sol,allr,allc]=aoc23_13_1solve(in)
allr=[];
allc=[];
out=aoc23_13_aux(in); % turns raw input data into cell of separate diagrams

for i1=1:length(out)
    [r,c]=aoc23_13_1(out{i1}); % get value of line of reflection (vertical:[r=0,c=#] horiztonal[r=#,c=0])
    allr=[allr;r];
    allc=[allc;c];
end

sol=sum(allr*100+allc); % weighted from problem statement

end