function output = convolution(m1,m2)

output = sum(sum(flip(flip(m1,1),2).*m2));

end

