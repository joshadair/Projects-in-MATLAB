function index = spot_the_outlier3(pts)
   for i=1:length(pts)
       temp = pts;
       temp(i,:) = [];
       x = temp(:,1);
       y = temp(:,2);
       
       mdl = fitlm(x,y);
       r2 = mdl.Rsquared.Ordinary;
       string_r2 = num2str(r2);
       
       if r2 == 1 | r2 == 0 | string_r2 == '1'
           index = i;
           return
       end
       
   end
       
end