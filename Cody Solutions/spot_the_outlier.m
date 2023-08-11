function outlier = spot_the_outlier(pts)
  outlier = [];
  ms = [];
  
  
% Terrible code, some weird stuff going on for further review  
  for x=1:length(pts)
      temp = pts;
      active = temp(x,:);
      temp(x,:) = [];
      
      for y=1:length(temp)
          m = (active(2)-temp(y,2))/(active(1)-temp(y,1));
          
          if abs(m-round(m)) < 2.2204e-14
              m = round(m);
          end
          
          
          if isempty(ms)
              ms(end+1) = m;                        
          elseif ismember(m,ms) & isempty(outlier)==0
              outlier = y;
              return
          elseif ismember(m,ms)
              continue
          elseif isempty(outlier)
              outlier = active;
              continue
          elseif isempty(outlier) == 0
              outlier = y-1;
              return   
          end
      end
  end
end