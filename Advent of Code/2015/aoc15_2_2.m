function ribbon = aoc15_2_2(dims)
dims=split(dims,'x');
l=str2double(dims{1});
w=str2double(dims{2});
h=str2double(dims{3});

ribbon=[2*l+2*w 2*l+2*h 2*w+2*h];
ribbon=min(ribbon)+l*w*h;
end