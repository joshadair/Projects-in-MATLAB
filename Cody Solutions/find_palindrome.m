function b = find_palindrome(a)
a = num2str(a) - '0';
flipa = flip(a);

if flipa == a
    b = polyval(a,10); 
else    
    b = find_palindrome(polyval(a+flipa,10)); 
end
  
end