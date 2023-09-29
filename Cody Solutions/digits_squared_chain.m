function y = digits_squared_chain(x)
y=x;
while (y~=89) && (y~=1)
    y=num2str(y)-'0';
    y=sum(y.^2);
end

end