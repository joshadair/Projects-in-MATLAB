function index = spot_the_outlier3(pts)
   for i=1:length(pts)
       temp = pts;
       temp(i,:) = [];
       x = temp(:,1);
       y = temp(:,2);
       [p,S] = polyfit(x,y,1);
       [y_fit,delta] = polyval(p,x,S);
       
       if delta ~= 0
           index = i
           return
       end
       
   end
       
end