function y = leadingDigit(x)
  y = [];
  for i1=1:length(x)
      a=char(string(x(i1)));
      a=a-'0';
      
      for i2=1:length(a)
          if a(i2)~=0 && a(i2)~=-3 && a(i2)~=-2
              y(end+1)=a(i2);
              break
          end
      end
  end
end