function output = float0s(input)
  output = [];
  [row, col] = size(input);
  
  for c=1:col
      temp = [];
      for r=1:row       
          if input(r,c) == 0;
              temp = [0; temp];
          else
              temp = [temp; input(r,c)];    
          end
      end
      output = [output, temp];
  end    
          
end