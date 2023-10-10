function paper = aoc15_2_1(dims)
dims=split(dims,'x');
l=str2double(dims{1});
w=str2double(dims{2});
h=str2double(dims{3});

paper=[2*l*w 2*l*h 2*w*h];
paper=min(paper)/2+sum(paper);
end
