function y = euler005(x)
y=[];
for i1=1:x
    newfactors=factor(i1);
    for i2=1:length(newfactors)
        if length(find(y==newfactors(i2)))<length(find(newfactors==newfactors(i2)));
            y(end+1)=newfactors(i2);
        end
    end
end

y=prod(y);

end