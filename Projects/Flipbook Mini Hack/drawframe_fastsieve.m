function o=drawframe_fastsieve(f)
% pixels correspond to natural numbers with index values being:
% 1 2 3 4 5
% 6 7 8 9 10
% ...
% 21 22 23 24 25
% if index value is prime than the pixel is 0 (black); otherwise, the index value (number) is
% composite and the pixel is 1 (white)

sf=1;
m=(sf*f)^2;
o=zeros(sf*f,sf*f);

o(1)=1;
a=2;

while a<m
    if o(a)==1
        a=a+1;
        continue
    end
    o(a+a:a:m)=1;
    a=a+1;
end

% update value for color image
% color based on last digit, need to first replace 1's with index value to
% return to prime number value
l=numel(o);
for i1=1:l
    if o(i1)==0
        o(i1)=mod(i1,10);
    elseif o(i1)==1
        o(i1)=0;
    end
end

o=o';
o=ind2rgb(o,turbo(10));
%imshow(o)

end
