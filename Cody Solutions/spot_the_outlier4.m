function index = spot_the_outlier4(pts);
pts = 10*pts;
x=pts(:,1);
y=pts(:,2);

first_slope = (y(2)-y(1))/(x(2)-x(1));

for i = 3:length(pts);
    next_slope = (y(i)-y(1))/(x(i)-x(1));
    
    if next_slope ~= first_slope & i == 3
        next1_slope = (y(i+1)-y(1))/(x(i+1)-x(1));       
        if next1_slope == first_slope
            index = 3;
            return
        elseif next1_slope == next_slope
            index = 2;
            return
        else
            index = 1;
            return
        end    
    elseif next_slope ~= first_slope
        index = i;
        return
    end
end

end
        
            