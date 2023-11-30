function o=squarematrix(n)
max=(n)^2;
o=[];
for i1=1:max^(1/2):max
    o=[o;i1:i1+(n-1)];
end
end