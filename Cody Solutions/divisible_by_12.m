function tf = divisible_by_12(n_str)
n=n_str-'0';
div3=0;
div4=0;
tf=0;

while sum(n)>9
    n=sum(n);
    n=num2str(n)-'0';
end
n=sum(n);
if ismember(n,[0 3 6 9])==1
    div3=1;
end

ones=str2num(n_str(end));
tens=str2num(n_str(end-1));
if ismember(tens,[0 2 4 6 8]) && ismember(ones,[0 4 8])
    div4 = 1;
elseif ismember(tens,[1 3 5 7 9]) && ismember(ones,[2 6])
    div4 = 1;
end

if (div3==1) && (div4==1)
    tf=1;
end

end
