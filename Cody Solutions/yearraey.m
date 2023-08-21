function y = yearraey(x)
  y=dec2bin(x);
  while strcmp(y,flip(y))==0
      y=bin2dec(y);
      y=y+1;
      y=dec2bin(y);
  end
  y=bin2dec(y)-x;     
end