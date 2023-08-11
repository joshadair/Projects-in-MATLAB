function outlier = spot_the_outlier2(pts)
slopes = [];
p1 = pts(1,:);

for x=2:length(pts);
    m = (p1(2)-pts(x,2))/(p1(1)-pts(x,1));
    
    if abs(m-round(m)) < 2.2204e-14        
        m = round(m); 
    end
    
    slopes(end+1) = m;
end

[u, x, y] = unique(slopes,'stable');

if length(u) == length(slopes)
    outlier = 1;
elseif x(2) == 2
    outlier = 2;
else
    outlier = x(2) + 1;
end

end
    