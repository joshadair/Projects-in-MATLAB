function o=aoc23_8_1(in1,in2,in3,script)
active='AAA';
i1=1;
o=1;

while strcmp(active,'ZZZ')==0
    index=find(strcmp(in1,active));
    d=script(i1);
    if d=='L'
        active=in2{index};
    elseif d=='R'
        active=in3{index};
    end
    if i1==293
        i1=1;
    else
        i1=i1+1;
    end
    o=o+1;
end
o=o-1;

end