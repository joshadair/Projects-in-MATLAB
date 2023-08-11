function out = solitairecipher(deck, n)
out = [];
for count=1:n
    i=find(deck==27);
    if i ~= 28 
        deck(i) = deck(i+1);
        deck(i+1) = 27;
    else
        deck=[deck(1), deck(i), deck(2:end-1)];
    end
    
    i=find(deck==28);
    if i ~= 28 & i ~= 27
        deck(i) = deck(i+1);
        deck(i+1) = deck(i+2);
        deck(i+2) = 28;
    elseif i==28
        deck = [deck(1:2), deck(i), deck(3:end-1)];
    elseif i==27
        deck = [deck(1), deck(i), deck(2:end-2) deck(end)];
    end
    
    i = find(deck>=27);
    deck = [deck(i(2)+1:end),deck(i(1):i(2)),deck(1:i(1)-1)];
    
    bottomcard = deck(end);
    if bottomcard >= 27
        bottomcard = 27;
    end
    deck = [deck(bottomcard+1:end-1), deck(1:bottomcard), deck(end)];
    
    out(end+1) = deck(deck(1));
end

end