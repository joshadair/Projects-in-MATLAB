function out=aoc23_13_aux(in)
out={};
temp=[];
for i1=1:length(in)
    a=in{i1};
    if isempty(a)
        out{end+1}=temp;
        temp=[];
    else
        temp=[temp;a];
    end
end
out{end+1}=temp;



end