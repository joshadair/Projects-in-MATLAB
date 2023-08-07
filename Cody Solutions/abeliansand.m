function B = abeliansand(A)
  [row,col] = size(A);
  
  for r=1:row
      for c=1:col
          if A(r,c) > 3
              if r == 1
                  A = [zeros(1,col); A];
                  r = 2;
                  row = row + 1;
              end
              
              if r == row
                  A = [A; zeros(1,col)];
                  row = row + 1;
              end
              
              if c == 1
                  A = [zeros(row,1), A];
                  c = 2;
                  col = col + 1;
              end
              
              if c == col
                  A = [A, zeros(row,1)];
                  col = col + 1;
              end
                            
              A(r-1,c) = A(r-1,c) + 1;
              A(r+1,c) = A(r+1,c) + 1;                               
              A(r,c-1) = A(r,c-1) + 1;              
              A(r,c+1) = A(r,c+1) + 1;              
              A(r,c) = A(r,c) - 4;
          end
      end
  end
  
  if sum(any(A>3)) > 0
      B = abeliansand(A);
  else
      B = A;
  end

end