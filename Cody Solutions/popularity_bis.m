function y = popularity_bis(x)
y=[];
freq=ones(1,length(x));
for i1=2:length(x)
    if x(i1)==x(i1-1)
        freq(i1)=freq(i1-1)+1;
        freq(i1-1)=0;
    end
end

while any(freq)==1
    [val,~]=max(freq);    
    y=[y sort(x(freq==val))];
    x(freq==val)=[];
    freq(freq==val)=[];  
end
    
        
end